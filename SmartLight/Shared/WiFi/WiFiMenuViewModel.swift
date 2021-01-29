//
//  WiFiMenuViewModel.swift
//  SmartLight
//
//  Created by Marcus Isaksson on 1/28/21.
//

import GRPC
import SwiftUI

class WiFiMenuViewModel: ObservableObject {
    @Published var isConnected = false
    @Published var client: Smartlight_LightClient? { didSet { isConnected = client != nil }}
    
    func connect(to host: String) {
        let group = PlatformSupport.makeEventLoopGroup(loopCount: 1)
        let channel = ClientConnection.insecure(group: group).connect(host: host, port: 50051)
        client = Smartlight_LightClient(channel: channel)
    }
}
