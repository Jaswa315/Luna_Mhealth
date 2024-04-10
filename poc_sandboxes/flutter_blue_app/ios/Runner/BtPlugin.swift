//
//  btPlugin.swift
//  Runner
//
//  Created by Shaun Stangler on 11/30/23.
//

import Foundation
import Flutter

public class BtPlugin: NSObject, FlutterPlugin {
    private var bluetoothManager: BluetoothManager?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "uw_luna_bt_native", binaryMessenger: registrar.messenger())
        let instance = BtPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        print("handle call: " + call.method)
        
        switch call.method {        
        case "startAdvertising":           
            startAdvertising(result: result)
        case "stopAdvertising":
            stopAdvertising(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func startAdvertising(result: FlutterResult) {
        if bluetoothManager == nil {
            bluetoothManager = BluetoothManager()
        }
        bluetoothManager?.startAdvertising()
        result(nil)
    }
    
    private func stopAdvertising(result: FlutterResult) {
        bluetoothManager?.stopAdvertising()
        result(nil)
    }
}
