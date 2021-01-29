//
//  Light.swift
//  SmartLight
//
//  Created by Marcus Isaksson on 1/27/21.
//

import SwiftUI

protocol Light: ObservableObject {
    var isOn: Bool { get set }
    var isOnPublished: Published<Bool> { get }
    var isOnPublisher: Published<Bool>.Publisher { get }
}
