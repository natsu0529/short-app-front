import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class ApiConfig {
  static const _port = '8000';
  static const _pcIpFromDefine = String.fromEnvironment('API_PC_IP');
  static const _fallbackPcIp = '192.168.1.15';

  static String get _pcIp =>
      _pcIpFromDefine.isNotEmpty ? _pcIpFromDefine : _fallbackPcIp;

  /// Resolves the API base URL depending on the platform/emulator/physical device.
  static Future<String> resolveBaseUrl() async {
    if (kIsWeb) {
      return 'http://localhost:$_port';
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
