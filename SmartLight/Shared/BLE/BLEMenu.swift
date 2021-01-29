//
//  BLEMenu.swift
//  SmartLight
//
//  Created by Marcus Isaksson on 1/28/21.
//

import SwiftUI
import CoreBluetooth

struct BLEMenu: View {
    @ObservedObject var searcher = BLESearcher()
    
    var destination: AnyView {
        guard searcher.connectedToPeripheral == true,
              let connectedPeripheral = searcher.connectedPeripheral else { return AnyView(EmptyView()) }
        return AnyView(LightView(light: BLELight(centralManager: searcher.centralManager, connectedPeripheral: connectedPeripheral)))
    }
    
    var body: some View {
        NavigationLink(destination: destination, isActive: $searcher.connectedToPeripheral) { EmptyView() }
        List {
            ForEach(searcher.peripherals) { peripheral in
                Button(peripheral.name ?? "No Name") {
                    searcher.connect(to: peripheral)
                }
            }
        }
    }
}

struct BLEMenu_Previews: PreviewProvider {
    static var previews: some View {
        BLEMenu()
    }
}
