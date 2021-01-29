//
//  WiFiMenu.swift
//  SmartLight
//
//  Created by Marcus Isaksson on 1/28/21.
//

import SwiftUI

struct WiFiMenu: View {
    @ObservedObject var viewModel = WiFiMenuViewModel()
    @State var ipAddress = "192.168.4.54"
    
    var destination: AnyView {
        guard let client = viewModel.client else { return AnyView(EmptyView()) }
        return AnyView(LightView(light: GRPCLight(connectedClient: client)))
    }
    
    var body: some View {
        VStack {
            NavigationLink(destination: destination, isActive: $viewModel.isConnected) { EmptyView() }
            TextField("IP Address", text: $ipAddress)
            Button("Connect") {
                viewModel.connect(to: ipAddress)
            }
        }
    }
}

struct WiFiMenu_Previews: PreviewProvider {
    static var previews: some View {
        WiFiMenu()
    }
}
