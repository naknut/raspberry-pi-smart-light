//
//  BLELight.swift
//  SmartLight
//
//  Created by Marcus Isaksson on 1/27/21.
//

import CoreBluetooth

class BLELight: NSObject, Light {
    private static let serviceUUID = CBUUID(string: "b2689aa8-36e3-4587-af74-072701200e7a")
    private static let characteristicUUID = CBUUID(string: "edf358c3-ab9e-43e3-8337-c1ce5d8e9464")
    private let centralManager: CBCentralManager
    private let peripheral: CBPeripheral
    private var characteristic: CBCharacteristic?
    
    @Published var isOn: Bool = false {
        didSet {
            guard let characteristic = characteristic else { return }
            peripheral.writeValue(Data([UInt8(isOn ? 1 : 0)]), for: characteristic, type: .withoutResponse)
        }
    }
    var isOnPublished: Published<Bool> { _isOn }
    var isOnPublisher: Published<Bool>.Publisher { $isOn }
    
    init(centralManager: CBCentralManager, connectedPeripheral: CBPeripheral) {
        self.centralManager = centralManager
        peripheral = connectedPeripheral
        super.init()
        peripheral.delegate = self
        peripheral.discoverServices([Self.serviceUUID])
    }
}

extension BLELight: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let service = peripheral.services?.first(where: { $0.uuid == BLELight.serviceUUID }) {
            peripheral.discoverCharacteristics([Self.characteristicUUID], for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristic = service.characteristics?.first(where: { $0.uuid == BLELight.characteristicUUID}) else {
            return
        }
        peripheral.readValue(for: characteristic)
        self.characteristic = characteristic
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value else { return }
        isOn = data.withUnsafeBytes { $0.load(as: UInt8.self) } != 0
    }
}
