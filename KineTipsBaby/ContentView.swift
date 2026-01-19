//
//  ContentView.swift
//  KineTipsBaby
//
//  Created by Cosmin Oprea on 19/01/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Label("Programs", systemImage: "house.fill")
                    }
                    .tag(0)
                
                BabyProgressView()
                    .tabItem {
                        Label("Progress", systemImage: "chart.line.uptrend.xyaxis")
                    }
                    .tag(1)
                
                TipsView()
                    .tabItem {
                        Label("Tips", systemImage: "lightbulb.fill")
                    }
                    .tag(2)
                
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
                    .tag(3)
            }
            .accentColor(.pink)
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
