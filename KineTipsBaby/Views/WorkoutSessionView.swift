//
//  WorkoutSessionView.swift
//  KineTipsBaby
//
//  Created on 2026
//

import SwiftUI

struct WorkoutSessionView: View {
    let program: BabyProgram
    let startFromIndex: Int
    @State private var currentExerciseIndex = 0
    @State private var isResting = true
    @State private var isPrep = true
    @State private var showingExercisePrep = false
    @State private var restTimeRemaining = 5
    @State private var exerciseTimeRemaining = 0
    @State private var isPaused = false
    @State private var showingQuitAlert = false
    @State private var showingCompletionAlert = false
    @State private var timer: Timer?
    @Environment(\.dismiss) var dismiss
    
    init(program: BabyProgram, startFromIndex: Int = 0) {
        self.program = program
        self.startFromIndex = startFromIndex
    }
    
    var currentExercise: BabyExercise? {
        guard currentExerciseIndex < program.exercises.count else { return nil }
        return program.exercises[currentExerciseIndex]
    }
    
    var progressPercentage: CGFloat {
        guard program.exercises.count > 0 else { return 0 }
        return CGFloat(currentExerciseIndex) / CGFloat(program.exercises.count)
    }
    
    var body: some View {
        ZStack {
            Color(red: 0.1, green: 0.1, blue: 0.1)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { showingQuitAlert = true }) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.primary)
                            .padding()
                    }
                    
                    Spacer()
                    
                    Text(program.themeTitle)
                        .font(.headline)
                    
                    Spacer()
                    
                    Text("\(currentExerciseIndex + 1)/\(program.exercises.count)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding()
                }
                .background(Color(red: 0.15, green: 0.15, blue: 0.15))
                
                // Progress Bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 4)
                        
                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: geometry.size.width * progressPercentage, height: 4)
                            .animation(.linear(duration: 0.3), value: progressPercentage)
                    }
                }
                .frame(height: 4)
                
                Spacer()
                
                if let exercise = currentExercise {
                    if showingExercisePrep {
                        ExercisePrepView(
                            exercise: exercise,
                            onStart: startExerciseAfterPrep
                        )
                    } else if isResting {
                        RestView(
                            isPrep: isPrep,
                            timeRemaining: restTimeRemaining,
                            nextExercise: exercise,
                            onSkip: skipRest
                        )
                    } else {
                        ExerciseWorkoutView(
                            exercise: exercise,
                            timeRemaining: exerciseTimeRemaining,
                            isPaused: isPaused,
                            onPause: togglePause,
                            onComplete: completeExercise
                        )
                    }
                } else {
                    VStack(spacing: 20) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.green)
                        
                        Text("Workout Complete!")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("Great job!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            startWorkout()
        }
        .onDisappear {
            stopTimer()
        }
        .alert("Quit Workout?", isPresented: $showingQuitAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Quit", role: .destructive) {
                // Save progress before quitting
                WorkoutProgressManager.shared.saveProgress(
                    programId: program.programId,
                    currentIndex: currentExerciseIndex,
                    totalExercises: program.exercises.count,
                    isCompleted: false
                )
                stopTimer()
                dismiss()
            }
        } message: {
            Text("Are you sure you want to quit? Your progress will be saved.")
        }
        .alert("Workout Complete!", isPresented: $showingCompletionAlert) {
            Button("Done") {
                dismiss()
            }
        } message: {
            Text("Great job! You completed all exercises.")
        }
    }
    
    private func startWorkout() {
        currentExerciseIndex = startFromIndex
        isResting = true
        isPrep = startFromIndex == 0
        restTimeRemaining = startFromIndex == 0 ? 5 : 10
        startTimer()
    }
    
    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if isPaused { return }
            
            if isResting {
                if restTimeRemaining > 0 {
                    restTimeRemaining -= 1
                } else {
                    stopTimer()
                    isResting = false
                    showingExercisePrep = true
                }
            } else {
                if let exercise = currentExercise, exercise.isTimedExercise {
                    if exerciseTimeRemaining > 0 {
                        exerciseTimeRemaining -= 1
                    } else {
                        completeExercise()
                    }
                }
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func startExercise() {
        guard let exercise = currentExercise else { return }
        isResting = false
        isPrep = false
        exerciseTimeRemaining = exercise.durationSeconds
    }
    
    private func completeExercise() {
        currentExerciseIndex += 1
        
        // Save progress
        WorkoutProgressManager.shared.saveProgress(
            programId: program.programId,
            currentIndex: currentExerciseIndex,
            totalExercises: program.exercises.count,
            isCompleted: currentExerciseIndex >= program.exercises.count
        )
        
        if currentExerciseIndex >= program.exercises.count {
            stopTimer()
            showingCompletionAlert = true
        } else {
            isResting = true
            isPrep = false
            restTimeRemaining = 10
        }
    }
    
    private func skipRest() {
        stopTimer()
        isResting = false
        showingExercisePrep = true
    }
    
    private func startExerciseAfterPrep() {
        showingExercisePrep = false
        startExercise()
        startTimer()
    }
    
    private func togglePause() {
        isPaused.toggle()
    }
}

struct RestView: View {
    let isPrep: Bool
    let timeRemaining: Int
    let nextExercise: BabyExercise?
    let onSkip: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Text(isPrep ? "Get Ready" : "Rest")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.primary)
            
            Text("\(timeRemaining)")
                .font(.system(size: 80, weight: .bold))
                .foregroundColor(.blue)
            
            if let exercise = nextExercise {
                VStack(spacing: 8) {
                    Text("Next Exercise")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(exercise.exerciseName)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
            
            Button(action: onSkip) {
                Text("Skip")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 120, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(UIColor.secondarySystemBackground))
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    ).padding()
            }
        }
        .padding()
    }
}

struct ExerciseWorkoutView: View {
    let exercise: BabyExercise
    let timeRemaining: Int
    let isPaused: Bool
    let onPause: () -> Void
    let onComplete: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            // Exercise Name
            Text(exercise.exerciseName)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .padding(.horizontal)
            
            // Video Placeholder
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.1))
                    .frame(height: 200)
                
                if let videoURL = exercise.videoURL {
                    Text("Video: \(videoURL)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else {
                    VStack(spacing: 8) {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.blue)
                        
                        Text("Video Coming Soon")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal)
            
            // Quick Instructions
            Text(exercise.exerciseDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .padding(.horizontal)
            
            Spacer()
            
            // Timer/Reps Section
            if exercise.isTimedExercise {
                VStack(spacing: 12) {
                    Text("\(timeRemaining)s")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.blue)
                    
                    HStack(spacing: 12) {
                        Button(action: onPause) {
                            HStack(spacing: 8) {
                                Image(systemName: isPaused ? "play.fill" : "pause.fill")
                                Text(isPaused ? "Resume" : "Pause")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(isPaused ? Color.green : Color.orange)
                            )
                        }
                        
                        Button(action: onComplete) {
                            Text("Skip")
                                .font(.headline)
                                .foregroundColor(.blue)
                                .frame(width: 100, height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.blue, lineWidth: 2)
                                )
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.blue.opacity(0.1))
                )
                .padding(.horizontal)
            } else {
                // Rep-based exercise
                VStack(spacing: 12) {
                    Text("\(exercise.repetitions) reps")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.blue)
                    
                    HStack(spacing: 12) {
                        Button(action: onComplete) {
                            Text("Done")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.green)
                                )
                        }
                        
                        Button(action: onComplete) {
                            Text("Skip")
                                .font(.headline)
                                .foregroundColor(.blue)
                                .frame(width: 100, height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.blue, lineWidth: 2)
                                )
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.blue.opacity(0.1))
                )
                .padding(.horizontal)
            }
        }
        .padding(.bottom, 20)
    }
}
