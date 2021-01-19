//
//  ContentView.swift
//  Shared
//
//  Created by Marcus Isaksson on 1/14/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var client = Client()
    
    var body: some View {
        Toggle("Light On", isOn: $client.isOn).padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
