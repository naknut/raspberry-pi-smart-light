//
//  GRPCLight.swift
//  SmartLight
//
//  Created by Marcus Isaksson on 1/14/21.
//

import Foundation
import GRPC
import SwiftProtobuf
import Combine

class GRPCLight: Light {
    @Published var isOn: Bool = false {
        didSet {
            _ = client.setIsOn(Google_Protobuf_BoolValue(booleanLiteral: isOn))
        }
    }
    var isOnPublished: Published<Bool> { _isOn }
    var isOnPublisher: Published<Bool>.Publisher { $isOn }
    
    private let client: Smartlight_LightClient
    private var isOnCancellable: AnyCancellable?
    
    init(connectedClient: Smartlight_LightClient) {
        client = connectedClient
        
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
