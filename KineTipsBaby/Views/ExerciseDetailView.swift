//
//  ExerciseDetailView.swift
//  KineTipsBaby
//
//  Created on 2026
//

import SwiftUI
import AVKit

struct ExerciseDetailView: View {
    let exercise: BabyExercise
    @State private var isPlaying = false
    @State private var timeRemaining: Int
    @State private var timer: Timer?
    
    init(exercise: BabyExercise) {
        self.exercise = exercise
        _timeRemaining = State(initialValue: exercise.durationSeconds)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 250)
                    
                    if let videoURL = exercise.videoURL {
                        VideoPlayerView(url: videoURL)
                            .frame(height: 250)
                            .cornerRadius(20)
                    } else {
                        VStack(spacing: 12) {
                            Image(systemName: "play.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.blue)
                            
                            Text("Video Coming Soon")
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text(exercise.exerciseName)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    HStack(spacing: 20) {
                        InfoBadge(icon: "clock.fill", text: exercise.durationText)
                        InfoBadge(icon: "calendar", text: exercise.ageRangeText)
                    }
                    
                    Divider()
                    
                    // Quick Step
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Quick Step")
                            .font(.headline)
                        Text(exercise.exerciseDescription)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                    
                    // Detailed Instructions
                    VStack(alignment: .leading, spacing: 8) {
                        Text("How to Perform")
                            .font(.headline)
                        Text(exercise.detailedInstructions)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                    }
                    
                    Divider()
                    
                    // Environment Setup
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Setup & Preparation")
                            .font(.headline)
                        Text(exercise.environmentSetup)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                    }
                    
                    Divider()
                    
                    // Parent Tips
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(.orange)
                            Text("Parent Tips")
                                .font(.headline)
                        }
                        Text(exercise.parentTips)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 0.2, green: 0.2, blue: 0.2))
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                )
                .padding(.horizontal)
                
                if exercise.isTimedExercise {
                    VStack(spacing: 16) {
                        Text("\(timeRemaining)s")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.blue)
                        
                        Button(action: toggleTimer) {
                            Text(isPlaying ? "Pause" : "Start")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(isPlaying ? Color.orange : Color.blue)
                                )
                        }
                        
                        Button(action: resetTimer) {
                            Text("Reset")
                                .font(.headline)
                                .foregroundColor(.blue)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.blue, lineWidth: 2)
                                )
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.blue.opacity(0.1))
                    )
                    .padding(.horizontal)
                }
            }
            .padding(.bottom, 20)
        }
        .background(Color(red: 0.1, green: 0.1, blue: 0.1))
        .navigationTitle("Exercise Details")
        .navigationBarTitleDisplayModeInline()
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func toggleTimer() {
        isPlaying.toggle()
        
        if isPlaying {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    timer?.invalidate()
                    isPlaying = false
                }
            }
        } else {
            timer?.invalidate()
        }
    }
    
    private func resetTimer() {
        timer?.invalidate()
        isPlaying = false
        timeRemaining = exercise.durationSeconds
    }
}

struct InfoBadge: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption)
            Text(text)
                .font(.caption)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.blue.opacity(0.1))
        )
    }
}

struct VideoPlayerView: View {
    let url: String
    
    var body: some View {
        if let videoURL = URL(string: url) {
            VideoPlayer(player: AVPlayer(url: videoURL))
        } else {
            Text("Invalid video URL")
                .foregroundColor(.secondary)
        }
    }
}
