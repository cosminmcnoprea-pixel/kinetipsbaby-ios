//
//  ProfileView.swift
//  KineTipsBaby
//
//  Created on 2026
//

import SwiftUI

struct ProfileView: View {
    @AppStorage("baby_name") private var babyName: String = ""
    @AppStorage("baby_age_months") private var babyAge: Int = 0
    @AppStorage("baby_age_set") private var babyAgeSet: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Baby Information")) {
                    TextField("Baby's Name", text: $babyName)
                    
                    Stepper("Age: \(babyAge) months", value: $babyAge, in: 0...18)
                }
                
                Section(header: Text("Settings")) {
                    NavigationLink("Notifications") {
                        Text("Notification Settings")
                    }
                    
                    NavigationLink("Privacy Policy") {
                        Text("Privacy Policy")
                    }
                    
                    NavigationLink("Terms of Service") {
                        Text("Terms of Service")
                    }
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Profile")
        }
        .onChange(of: babyAge) { _ in
            babyAgeSet = true
        }
    }
}
