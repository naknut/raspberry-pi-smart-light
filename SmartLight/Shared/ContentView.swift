//
//  ContentView.swift
//  Shared
//
//  Created by Marcus Isaksson on 1/14/21.
//

import SwiftUI

struct ContentView: View {
    let client = Client()
    
    var body: some View {
        VStack {
            Button("Toggle On") { client.setIsOn(true) }
            Button("Toggle Off") { client.setIsOn(false) }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
