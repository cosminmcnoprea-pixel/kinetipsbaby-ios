//
//  KineTipsBabyApp.swift
//  KineTipsBaby
//
//  Created by Cosmin Oprea on 19/01/2026.
//

import SwiftUI

@main
struct KineTipsBabyApp: App {
    init() {
        // Force dark mode for the entire app
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = .dark
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
