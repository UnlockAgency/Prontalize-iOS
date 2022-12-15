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
            Group {
                Divider()
                Text("This will not use prontalize")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text("welcome", bundle: .main)
            }
            Group {
                Divider()
                Text("This will not update live")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text("welcome", bundle: .prontalize)
                
                Text(String(format: NSLocalizedString("apples", bundle: .prontalize, comment: ""), 9))
            }
            
            Group {
                Divider()
                Text("This will update live")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text("welcome")
                    .foregroundColor(.green)
                    .font(.largeTitle)
                
                ProntalizedText("apples", pluralCount: 3)
                
                VStack(spacing: 10) {
                    SomeText()
                }
                .padding()
                .background(.red)
                
                Divider()
            }
            
            Group {
                Button("Refresh") {
                    Prontalize.instance.refresh()
                }
                
                Button("Enable / disable") {
                    Prontalize.instance.isEnabled.toggle()
                }
                
                NavigationLink("Open next screen") {
                    ContentView2()
                }
            }
        }
        .padding()
    }
}

private struct SomeText: View {
    @ObservedObject private var prontalize = Prontalize.instance
    
    var body: some View {
        Text("welcome", bundle: .prontalize)
            .foregroundColor(.white)
    }
}


struct ContentView2: View {
    var body: some View {
        VStack(spacing: 20) {
            
            Group {
                Divider()
                Text("This will not update live")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text("welcome", bundle: .prontalize)
                    .foregroundColor(.red)
                    .font(.largeTitle)
                
                Text(String(format: NSLocalizedString("apples", bundle: .prontalize, comment: ""), 8))
            }
            
            Group {
                Divider()
                Text("This will update live")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                ProntalizedText("welcome")
                    .foregroundColor(.orange)
                    .font(.largeTitle)
            }
            Divider()
            
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
