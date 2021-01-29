//
//  BLEClient.swift
//  SmartLight
//
//  Created by Marcus Isaksson on 1/27/21.
//

import CoreBluetooth

class BLESearcher: NSObject, ObservableObject, CBCentralManagerDelegate {
    private static let serviceUUID = CBUUID(string: "b2689aa8-36e3-4587-af74-072701200e7a")
    
    let centralManager = CBCentralManager()
    private(set) var connectedPeripheral: CBPeripheral?
    
    @Published var peripherals: [CBPeripheral] = []
    @Published var connectedToPeripheral = false
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print(BLESearcher.serviceUUID)
        print(BLESearcher.serviceUUID.uuidString)
        if central.state == .poweredOn {
            central.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        guard !peripherals.contains(peripheral) else { return }
        peripherals.append(peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        connectedPeripheral = peripheral
        connectedToPeripheral = true
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        connectedPeripheral = nil
        connectedToPeripheral = false
    }
    
    func connect(to peripheral: CBPeripheral) {
        centralManager.stopScan()
        centralManager.connect(peripheral, options: nil)
    }
    
    override init() {
        super.init()
        centralManager.delegate = self
    }
    
    deinit {
        centralManager.stopScan()
    }
}

extension CBPeripheral: Identifiable {
    
}
