//
//  MainMenu.swift
//  SmartLight
//
//  Created by Marcus Isaksson on 1/28/21.
//

import SwiftUI

struct MainMenu: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: WiFiMenu()) {
                    Text("Wifi")
                }
                NavigationLink(destination: BLEMenu()) {
                    Text("Bluetooth")
                }
            }
        }
    }
}

struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        MainMenu()
    }
}
