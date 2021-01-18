//
//  Client.swift
//  SmartLight
//
//  Created by Marcus Isaksson on 1/14/21.
//

import Foundation
import GRPC
import SwiftProtobuf

class Client {
    let client: Smartlight_LightClient
    
    init() {
        let group = PlatformSupport.makeEventLoopGroup(loopCount: 1)
        let channel = ClientConnection.insecure(group: group).connect(host: "192.168.4.54", port: 50051)
        client = Smartlight_LightClient(channel: channel)
    }
    
    func isOn() -> Bool {
        try! client.getIsOn(Google_Protobuf_Empty()).response.wait().value
    }
    
    func setIsOn(_ isOn: Bool) {
        _ = try! client.setIsOn(Google_Protobuf_BoolValue(booleanLiteral: isOn)).response.wait()
    }
}
