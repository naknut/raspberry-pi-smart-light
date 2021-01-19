//
//  Client.swift
//  SmartLight
//
//  Created by Marcus Isaksson on 1/14/21.
//

import Foundation
import GRPC
import SwiftProtobuf
import Combine

class Client: ObservableObject {
    @Published var isOn: Bool = false {
        didSet {
            _ = client.setIsOn(Google_Protobuf_BoolValue(booleanLiteral: isOn))
        }
    }
    
    private let client: Smartlight_LightClient
    private var isOnCancellable: AnyCancellable?
    
    init() {
        let group = PlatformSupport.makeEventLoopGroup(loopCount: 1)
        let channel = ClientConnection.insecure(group: group).connect(host: "192.168.4.54", port: 50051)
        client = Smartlight_LightClient(channel: channel)
        
        isOnCancellable =
            Future<Google_Protobuf_BoolValue, Error>() { [weak client] promise in
                client?.getIsOn(Google_Protobuf_Empty()).response.whenComplete { return promise($0) }
            }
            .assertNoFailure()
            .map { $0.value }
            .receive(on: RunLoop.main)
            .assign(to: \.isOn, on: self)
    }
}
