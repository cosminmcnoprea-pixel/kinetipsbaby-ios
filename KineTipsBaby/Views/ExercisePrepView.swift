//
//  ExercisePrepView.swift
//  KineTipsBaby
//
//  Created on 2026
//

import SwiftUI

struct ExercisePrepView: View {
    let exercise: BabyExercise
    let onStart: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            // Exercise Name
            Text(exercise.exerciseName)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Duration/Reps Badge
            HStack(spacing: 12) {
                Image(systemName: exercise.isTimedExercise ? "clock.fill" : "repeat.circle.fill")
                    .foregroundColor(.blue)
                Text(exercise.durationText)
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue.opacity(0.1))
            )
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Environment Setup
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.title3)
                            Text("Setup & Preparation")
                                .font(.headline)
                        }
                        
                        Text(exercise.environmentSetup)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(red: 0.2, green: 0.2, blue: 0.2))
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    )
                    
                    // How to Perform
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "list.number")
                                .foregroundColor(.blue)
                                .font(.title3)
                            Text("How to Perform")
                                .font(.headline)
                        }
                        
                        Text(exercise.detailedInstructions)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(red: 0.2, green: 0.2, blue: 0.2))
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    )
                    
                    // Parent Tips
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(.orange)
                                .font(.title3)
                            Text("Parent Tips")
                                .font(.headline)
                        }
                        
                        Text(exercise.parentTips)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(red: 0.2, green: 0.2, blue: 0.2))
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    )
                }
                .padding(.horizontal)
            }
            
            // Start Button
            Button(action: onStart) {
                HStack(spacing: 8) {
                    Image(systemName: "play.fill")
                    Text("Start Exercise")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.green)
                )
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(Color(red: 0.1, green: 0.1, blue: 0.1))
    }
}
