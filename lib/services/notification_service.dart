import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'api_client.dart';

/// バックグラウンドメッセージハンドラ（トップレベル関数である必要がある）
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    print('Background message: ${message.messageId}');
  }
}

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final ApiClient _apiClient;

  NotificationService(this._apiClient);

  /// FCMを初期化
  Future<void> initialize() async {
    // バックグラウンドハンドラを設定
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 通知権限をリクエスト
    await _requestPermission();

    // フォアグラウンドでの通知表示設定（iOS）
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // フォアグラウンドメッセージのリスナー
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // 通知タップ時のハンドラ
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // アプリが終了状態から通知で起動した場合
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }

  /// 通知権限をリクエスト
  Future<bool> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    final granted = settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;

    if (kDebugMode) {
      print('Notification permission: ${settings.authorizationStatus}');
    }

    return granted;
  }

  /// デバイストークンを取得してバックエンドに登録
  Future<void> registerDeviceToken() async {
    try {
      String? token;

      if (Platform.isIOS) {
        // iOSではAPNsトークンが必要
        final apnsToken = await _messaging.getAPNSToken();
        if (apnsToken == null) {
          if (kDebugMode) {
            print('APNs token not available yet');
          }
          return;
        }
      }

      token = await _messaging.getToken();

      if (token != null) {
        await _sendTokenToServer(token);
        if (kDebugMode) {
          print('FCM Token registered: ${token.substring(0, 20)}...');
        }
      }

      // トークンが更新された場合のリスナー
      _messaging.onTokenRefresh.listen(_sendTokenToServer);
    } catch (e) {
      if (kDebugMode) {
        print('Error registering device token: $e');
      }
    }
  }

  /// トークンをサーバーに送信
  Future<void> _sendTokenToServer(String token) async {
    try {
      final deviceType = Platform.isIOS ? 'ios' : 'android';
      await _apiClient.post<void>(
        '/api/device-token/',
        data: {
          'token': token,
          'device_type': deviceType,
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error sending token to server: $e');
      }
    }
  }

  /// デバイストークンを削除（ログアウト時）
  Future<void> unregisterDeviceToken() async {
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        await _apiClient.delete<void>(
          '/api/device-token/',
          data: {'token': token},
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error unregistering device token: $e');
      }
    }
  }

  /// フォアグラウンドメッセージの処理
  void _handleForegroundMessage(RemoteMessage message) {
    if (kDebugMode) {
      print('Foreground message: ${message.notification?.title}');
    }
    // フォアグラウンドでは自動的に通知が表示される（iOS設定済み）
    // Androidの場合はローカル通知を表示する必要がある場合がある
  }

  /// 通知タップ時の処理
  void _handleNotificationTap(RemoteMessage message) {
    if (kDebugMode) {
      print('Notification tapped: ${message.data}');
    }
    // TODO: 通知の種類に応じて画面遷移を行う
    // 例: message.data['type'] == 'like' の場合は投稿詳細へ遷移
  }
}
