//
//  ExerciseDetailView.swift
//  KineTipsBaby
//
//  Created on 2026
//

import SwiftUI
import AVKit

private struct ExerciseScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ExerciseDetailView: View {
    let exercise: BabyExercise
    @State private var isPlaying = false
    @State private var timeRemaining: Int
    @State private var timer: Timer?
    @State private var scrollOffset: CGFloat = 0
    
    init(exercise: BabyExercise) {
        self.exercise = exercise
        _timeRemaining = State(initialValue: exercise.durationSeconds)
    }
    
    var body: some View {
        ExerciseContentView(exercise: exercise, scrollOffset: $scrollOffset)
            .background(Color(red: 0.1, green: 0.1, blue: 0.1))
            .navigationTitle("Exercise Details")
            .navigationBarTitleDisplayModeInline()
            .safeAreaInset(edge: .bottom) {
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
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                            .opacity(controlsBackgroundOpacity)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    )
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
            }
            .onDisappear {
                timer?.invalidate()
            }
    }

    private var controlsBackgroundOpacity: Double {
        // scrollOffset is ~0 at top; becomes negative when you scroll down.
        let scrolled = max(0, Double(-scrollOffset))
        let t = min(max(scrolled / 140.0, 0.0), 1.0)
        return 1.0 - (0.8 * t)
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

struct ExerciseContentView: View {
    let exercise: BabyExercise
    @Binding var scrollOffset: CGFloat
    @State private var showHowToPerform = false
    @State private var showSetup = false
    @State private var showTips = false
    @State private var initialScrollMinY: CGFloat?

    var body: some View {
        ScrollView {
            GeometryReader { proxy in
                Color.clear
                    .preference(
                        key: ExerciseScrollOffsetPreferenceKey.self,
                        value: proxy.frame(in: .named("exerciseScroll")).minY
                    )
            }
            .frame(height: 0)

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
                    DisclosureGroup(isExpanded: $showHowToPerform) {
                        Text(exercise.detailedInstructions)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                            .padding(.top, 6)
                    } label: {
                        Text("How to Perform")
                            .font(.headline)
                    }

                    Divider()
                    
                    // Environment Setup
                    DisclosureGroup(isExpanded: $showSetup) {
                        Text(exercise.environmentSetup)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                            .padding(.top, 6)
                    } label: {
                        Text("Setup & Preparation")
                            .font(.headline)
                    }
                    
                    Divider()
                    
                    // Parent Tips
                    DisclosureGroup(isExpanded: $showTips) {
                        Text(exercise.parentTips)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                            .padding(.top, 6)
                    } label: {
                        HStack {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(.orange)
                            Text("Parent Tips")
                                .font(.headline)
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 0.2, green: 0.2, blue: 0.2))
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                )
                .padding(.horizontal)
            }
            .padding(.bottom, 20)
        }
        .coordinateSpace(name: "exerciseScroll")
        .onPreferenceChange(ExerciseScrollOffsetPreferenceKey.self) { value in
            if initialScrollMinY == nil {
                initialScrollMinY = value
            }
            scrollOffset = value - (initialScrollMinY ?? value)
        }
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
