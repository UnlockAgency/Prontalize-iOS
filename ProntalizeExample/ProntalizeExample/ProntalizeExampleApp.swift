//
//  ProntalizeExampleApp.swift
//  ProntalizeExample
//
//  Created by Bas van Kuijck on 14/12/2022.
//

import SwiftUI
import Prontalize

@main
struct ProntalizeExampleApp: App {
    init() {
#if DEBUG
        Prontalize.instance.debugModus = true
#endif
        
        // Make sure to set the PRONTALIZE_API_TOKEN and PRONTALIZE_PROJECT_ID in your (private) scheme
        Prontalize.instance.setup(
            apiToken: ProcessInfo.processInfo.environment["PRONTALIZE_API_TOKEN"] ?? "",
            projectID: ProcessInfo.processInfo.environment["PRONTALIZE_PROJECT_ID"] ?? ""
        )
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }
    }
}
