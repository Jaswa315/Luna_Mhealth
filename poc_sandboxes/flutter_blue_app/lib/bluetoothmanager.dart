import 'package:flutter/services.dart';
import 'dart:developer' as developer;

class BluetoothManager {
  static const MethodChannel _channel = const MethodChannel('uw_luna_bt_native');

  static Future<void> startAdvertising() async {
    try {
      developer.log('BTManager: Attempting starting advertising');
      await _channel.invokeMethod('startAdvertising');
    } on PlatformException catch (e) {
      developer.log('Error starting advertising: ${e.message}');
    }
  }

  static Future<void> stopAdvertising() async {
    try {
      developer.log('BTManager: Attempting stopping advertising');
      await _channel.invokeMethod('stopAdvertising');
    } on PlatformException catch (e) {
      developer.log('Error stopping advertising: ${e.message}');
    }
  }
}