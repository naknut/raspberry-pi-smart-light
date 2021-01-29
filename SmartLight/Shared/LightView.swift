//
//  ContentView.swift
//  Shared
//
//  Created by Marcus Isaksson on 1/14/21.
//

import SwiftUI

struct LightView<L: Light>: View {
    @ObservedObject var light: L
    
    var body: some View {
        Toggle("Light On", isOn: $light.isOn).padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LightView(light: MockLight())
    }
}
