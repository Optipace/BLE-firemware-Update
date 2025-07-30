import 'package:flutter/services.dart';

class DevOptionsChecker {
  static const MethodChannel _channel = MethodChannel('dev_options_channel');

  static Future<bool> isDevOptionsEnabled() async {
    try {
      final bool result = await _channel.invokeMethod('checkDevOptions');
      return result;
    } catch (e) {
      print("Error checking developer options: $e");
      return false;
    }
  }
}
