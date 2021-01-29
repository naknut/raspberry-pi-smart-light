//
//  MockLight.swift
//  SmartLight
//
//  Created by Marcus Isaksson on 1/27/21.
//

import Combine

class MockLight: Light {
    @Published var isOn = false
    var isOnPublished: Published<Bool> { _isOn }
    var isOnPublisher: Published<Bool>.Publisher { $isOn }
}
