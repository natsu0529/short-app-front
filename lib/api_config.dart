import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static const _port = '8000';

  static String get _env => dotenv.env['ENV'] ?? 'local';
  static String get _localApiUrl =>
      dotenv.env['LOCAL_API_URL'] ?? 'http://localhost:$_port';
  static String get _prodApiUrl =>
      dotenv.env['PROD_API_URL'] ?? 'https://your-api.example.com';
  static String get _pcIp => dotenv.env['LOCAL_PC_IP'] ?? '192.168.1.15';

  static bool get isProduction => _env == 'production' || kReleaseMode;

  /// Resolves the API base URL depending on the environment and platform.
  static Future<String> resolveBaseUrl() async {
    // Production environment - always use production URL
    if (isProduction || kReleaseMode) {
      return _prodApiUrl;
    }

    // Local development
    if (kIsWeb) {
      return _localApiUrl;
    }

    if (Platform.isAndroid) {
      final info = await DeviceInfoPlugin().androidInfo;
      if (info.isPhysicalDevice) {
        return 'http://$_pcIp:$_port';
      }
      return 'http://10.0.2.2:$_port';
    }

    if (Platform.isIOS) {
      final info = await DeviceInfoPlugin().iosInfo;
      if (info.isPhysicalDevice) {
        return 'http://$_pcIp:$_port';
      }
      return 'http://127.0.0.1:$_port';
    }

    return 'http://127.0.0.1:$_port';
  }
}
