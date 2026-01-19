//
//  ProgramDetailView.swift
//  KineTipsBaby
//
//  Created on 2026
//

import SwiftUI
import Combine

struct ProgramDetailView: View {
    let programId: String
    @State private var program: BabyProgram?
    @State private var savedProgress: WorkoutProgress?

    private var completedExerciseCount: Int {
        guard let program else { return 0 }
        if savedProgress?.isCompleted == true { return program.exercises.count }
        return savedProgress?.currentExerciseIndex ?? 0
    }
    
    var body: some View {
        ScrollView {
            if let program = program {
                VStack(spacing: 20) {
                    VStack(spacing: 12) {
                        Text(program.themeTitle)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)

                        if savedProgress?.isCompleted == true {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(.green)
                                Text("Completed")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.green)
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(red: 0.15, green: 0.15, blue: 0.15))
                            )
                        }
                        
                        Text(program.ageRangeText)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(.orange)
                                Text("Parent Tips")
                                    .font(.headline)
                                    .foregroundColor(Color(UIColor.label))
                            }
                            
                            Text(program.themeHint)
                                .font(.subheadline)
                                .foregroundColor(Color(UIColor.label))
                                .lineSpacing(4)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(red: 0.2, green: 0.2, blue: 0.2))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.orange, lineWidth: 2)
                        )
                    }
                    .padding()
                    
                    // Progress indicator
                    if let progress = savedProgress, !progress.isCompleted {
                        VStack(spacing: 12) {
                            HStack {
                                Image(systemName: "chart.bar.fill")
                                    .foregroundColor(.blue)
                                Text("Progress: \(progress.currentExerciseIndex)/\(progress.totalExercises) exercises")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(UIColor.label))
                                Spacer()
                            }
                            
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color(UIColor.systemGray4))
                                        .frame(height: 10)
                                    
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color.blue)
                                        .frame(width: geometry.size.width * CGFloat(progress.currentExerciseIndex) / CGFloat(progress.totalExercises), height: 10)
                                }
                            }
                            .frame(height: 10)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(red: 0.2, green: 0.2, blue: 0.2))
                        )
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                    }
                    
                    // Workout buttons
                    if let progress = savedProgress, !progress.isCompleted, progress.currentExerciseIndex > 0 {
                        HStack(spacing: 12) {
                            NavigationLink(destination: WorkoutSessionView(program: program, startFromIndex: progress.currentExerciseIndex)) {
                                Text("Resume")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color.green)
                                    )
                            }
                            
                            NavigationLink(destination: WorkoutSessionView(program: program, startFromIndex: 0)) {
                                Text("Restart")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.blue, lineWidth: 2)
                                    )
                            }
                        }
                        .padding(.horizontal)
                    } else {
                        NavigationLink(destination: WorkoutSessionView(program: program, startFromIndex: 0)) {
                            Text(savedProgress?.isCompleted == true ? "Start Again" : "Start Workout")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.blue)
                                )
                        }
                        .padding(.horizontal)
                    }
                    
                    Text("Exercises")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 8)
                    
                    VStack(spacing: 12) {
                        ForEach(Array(program.exercises.enumerated()), id: \.element.id) { index, exercise in
                            NavigationLink(destination: ExerciseDetailView(exercise: exercise)) {
                                ExerciseRow(
                                    exercise: exercise,
                                    index: index + 1,
                                    isCompleted: index < completedExerciseCount
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 20)
            } else {
                ProgressView("Loading program...")
                    .padding()
            }
        }
        .background(Color(red: 0.1, green: 0.1, blue: 0.1))
        .navigationTitle("Program Details")
        .navigationBarTitleDisplayModeInline()
        .onAppear {
            loadProgram()
        }
        .onReceive(NotificationCenter.default.publisher(for: .workoutProgressDidChange)) { notification in
            if let changedProgramId = notification.userInfo?["programId"] as? String {
                guard changedProgramId == programId else { return }
            }
            savedProgress = WorkoutProgressManager.shared.getProgress(for: programId)
        }
    }
    
    private func loadProgram() {
        program = BabyExerciseDataGenerator.generateThemeExercises(programId: programId)
        savedProgress = WorkoutProgressManager.shared.getProgress(for: programId)
    }
}

struct ExerciseRow: View {
    let exercise: BabyExercise
    let index: Int
    let isCompleted: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Text("\(index)")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(Circle().fill(Color.blue))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(exercise.exerciseName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(exercise.durationText)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()

            if isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.title3)
            } else {
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(red: 0.15, green: 0.15, blue: 0.15))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(UIColor.separator), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
}
