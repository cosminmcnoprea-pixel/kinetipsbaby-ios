//
//  ProgressView.swift
//  KineTipsBaby
//
//  Created on 2026
//

import SwiftUI

struct BabyProgressView: View {
    @State private var exercisesCompleted: Int = 0
    @State private var totalMinutes: Int = 0
    @State private var currentStreakDays: Int = 0

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Track Your Baby's Progress")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    VStack(spacing: 16) {
                        ProgressCard(
                            title: "Exercises Completed",
                            value: "\(exercisesCompleted)",
                            icon: "checkmark.circle.fill",
                            color: .green
                        )
                        
                        ProgressCard(
                            title: "Total Time",
                            value: "\(totalMinutes) min",
                            icon: "clock.fill",
                            color: .blue
                        )
                        
                        ProgressCard(
                            title: "Current Streak",
                            value: "\(currentStreakDays) \(currentStreakDays == 1 ? "day" : "days")",
                            icon: "flame.fill",
                            color: .orange
                        )
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color(red: 0.1, green: 0.1, blue: 0.1))
            .navigationTitle("Progress")
        }
        .onAppear {
            refreshStats()
        }
        .onReceive(NotificationCenter.default.publisher(for: .workoutProgressDidChange)) { _ in
            refreshStats()
        }
    }

    private func refreshStats() {
        let stats = WorkoutProgressManager.shared.getTodayStats()
        exercisesCompleted = stats.exercisesCompleted
        totalMinutes = stats.totalMinutes
        currentStreakDays = stats.themesCompleted > 0 ? 1 : 0
    }
}

struct ProgressCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.white)
                
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(red: 0.15, green: 0.15, blue: 0.15))
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
}
