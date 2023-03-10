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
        
        guard let apiToken = ProcessInfo.processInfo.environment["PRONTALIZE_API_TOKEN"],
              let projectID = ProcessInfo.processInfo.environment["PRONTALIZE_PROJECT_ID"] else {
            print("Warning - missing apiToken and/or projectID")
            return
        }
        
        // Make sure to set the PRONTALIZE_API_TOKEN and PRONTALIZE_PROJECT_ID in your (private) scheme
        Prontalize.instance.setup(
            apiToken: apiToken,
            projectID: projectID
        )
        
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { _ in
            Prontalize.instance.refresh()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }
    }
}
