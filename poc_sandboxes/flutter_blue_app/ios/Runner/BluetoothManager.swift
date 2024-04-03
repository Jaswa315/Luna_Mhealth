//
//  BluetoothManager.swift
//  SwiftBTTester
//
//  Created by Shaun Stangler on 11/28/23.
//

import Foundation
import CoreBluetooth


class BluetoothManager: NSObject, CBPeripheralManagerDelegate {

    // Define your service and characteristic UUIDs
    let serviceUUID = CBUUID(string: "00007577-0062-0000-0000-006875736b79")
    let characteristicTransferUUID = CBUUID(string: "00007578-0062-1000-0000-006875736b79")
    let characteristicQueueUUID = CBUUID(string: "00007579-0062-1000-0000-006875736b79")
    
    var peripheralManager: CBPeripheralManager!
    var service: CBMutableService!
    
    var isAdvertising: Bool = false

    override init() {
        super.init()
        print("IOS BTManager: Perhiperal Manager Init");
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }

    func setupService() {
        print("IOS BTManager: Setup Service");
        let characteristic = CBMutableCharacteristic(
            type: characteristicTransferUUID,
            properties: [.read, .write, .notify],
            value: nil,
            permissions: [.readable, .writeable]
        )

        service = CBMutableService(type: serviceUUID, primary: true)
        service.characteristics = [characteristic]

        peripheralManager.add(service)
    }

    func startAdvertising() {
        print("IOS BTManager: Start Advertising");
        setupService()
        print("Perhiperal Manager is Advertising Already?: \(peripheralManager.isAdvertising)");
        peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [serviceUUID]])
        isAdvertising = true
    }

    func stopAdvertising() {
        print("IOS BTManager: Start Advertising");
        peripheralManager.stopAdvertising()
        peripheralManager.remove(service)
        isAdvertising = false
    }

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print("Perhiperal Manager State Updating: \(peripheral.state)")
        switch peripheral.state {
            case .poweredOn:
                // Start or resume advertising when Bluetooth is powered on
                print("IOS BTManager: State PoweredOn.  Peripherial Manager BT starting!")

                startAdvertising()
            
            case .poweredOff, .resetting:
                // Stop advertising or take appropriate actions
                if (isAdvertising) {
                    print("IOS BTManager: State stopping.  Stopping advertising!")
                    stopAdvertising()
                }
            // Handle other states as needed
            default:
                break
            }
        print("Perhiperal Manager State Updated: \(peripheral.state)")
    }

    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if let error = error {
            print("Error advertising: \(error.localizedDescription)")
        } else {
            print("Advertising started successfully!")
        }
    }
}
