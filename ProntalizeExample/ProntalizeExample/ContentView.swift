//
//  ContentView.swift
//  ProntalizeExample
//
//  Created by Bas van Kuijck on 14/12/2022.
//

import SwiftUI
import Prontalize

struct ContentView: View {
    var body: some View {
            VStack(spacing: 20) {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text(Localized.get("welcome"))
                    .foregroundColor(.green)
                    .font(.largeTitle)
                
                Text(Localized.plural("apples", 3))
                
                Button("Refresh") {
                    Prontalize.instance.refresh()
                }
                
                NavigationLink("Open next screen") {
                    ContentView2()
                }
            }
        .padding()
    }
}


struct ContentView2: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.red)
            Text(Localized.get("welcome"))
                .foregroundColor(.red)
                .font(.largeTitle)
            
            Button("Refresh") {
                Prontalize.instance.refresh()
            }
        }
        .padding()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
