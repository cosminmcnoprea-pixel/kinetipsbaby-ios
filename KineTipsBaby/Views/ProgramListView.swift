//
//  ProgramListView.swift
//  KineTipsBaby
//
//  Created on 2026
//

import SwiftUI
import Combine

struct ProgramListView: View {
    let category: BabyCategory
    let themes: [(slug: String, title: String)]
    
    init(category: BabyCategory) {
        self.category = category
        self.themes = BabyExerciseDataGenerator.getThemesForCategory(categoryId: category.categoryId)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack(spacing: 8) {
                    Text(category.icon)
                        .font(.system(size: 60))
                    
                    Text(category.title)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(category.ageRangeText)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(colorForCategory(category.color).opacity(0.2))
                )
                .padding(.horizontal, 24)
                .padding(.top, 10)
                
                ForEach(themes, id: \.slug) { theme in
                    NavigationLink(destination: ProgramDetailView(
                        programId: "\(category.categoryId)_th_\(theme.slug)"
                    )) {
                        ThemeCard(
                            theme: theme,
                            color: category.color,
                            programId: "\(category.categoryId)_th_\(theme.slug)"
                        )
                    }
                    .padding(.horizontal, 32)
                }
            }
            .padding(.bottom, 24)
        }
        .background(Color(red: 0.1, green: 0.1, blue: 0.1))
        .navigationTitle("Select Theme")
        .navigationBarTitleDisplayModeInline()
        .onAppear {
            // Trigger view refresh to update progress badges
        }
    }
    
    func colorForCategory(_ colorName: String) -> Color {
        switch colorName {
        case "pastelPink": return Color(red: 1.0, green: 0.82, blue: 0.89)
        case "pastelBlue": return Color(red: 0.82, green: 0.89, blue: 1.0)
        case "pastelGreen": return Color(red: 0.85, green: 1.0, blue: 0.85)
        case "pastelYellow": return Color(red: 1.0, green: 1.0, blue: 0.75)
        case "pastelPurple": return Color(red: 0.95, green: 0.82, blue: 1.0)
        case "pastelOrange": return Color(red: 1.0, green: 0.9, blue: 0.78)
        case "pastelMint": return Color(red: 0.85, green: 1.0, blue: 0.95)
        default: return Color.gray
        }
    }
}

struct ThemeCard: View {
    let theme: (slug: String, title: String)
    let color: String
    let programId: String
    @State private var completedToday: Int = 0
    @State private var isThemeCompleted: Bool = false
    @State private var currentIndex: Int = 0
    @State private var totalExercises: Int = 10
    @State private var progressFraction: CGFloat = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(theme.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                Spacer()
                
                if isThemeCompleted {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.white)
                            .font(.caption)
                        Text("Completed")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.green)
                    )
                } else if completedToday > 0 {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.white)
                            .font(.caption)
                        Text("\(completedToday)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.green)
                    )
                }
            }
            
            Text("10 exercises")
                .font(.caption2)
                .foregroundColor(.secondary)

            VStack(alignment: .leading, spacing: 6) {
                Text("Progress: \(currentIndex)/\(totalExercises)")
                    .font(.caption2)
                    .foregroundColor(.secondary)

                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white.opacity(0.12))
                            .frame(height: 6)

                        RoundedRectangle(cornerRadius: 4)
                            .fill(isThemeCompleted ? Color.green : Color.blue)
                            .frame(width: geometry.size.width * progressFraction, height: 6)
                    }
                }
                .frame(height: 6)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(red: 0.15, green: 0.15, blue: 0.15))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(colorForCategory(color), lineWidth: 3)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .onAppear {
            refreshProgress()
        }
        .onReceive(NotificationCenter.default.publisher(for: .workoutProgressDidChange)) { notification in
            if let changedProgramId = notification.userInfo?["programId"] as? String {
                guard changedProgramId == programId else { return }
            }
            refreshProgress()
        }
    }

    private func refreshProgress() {
        completedToday = WorkoutProgressManager.shared.getCompletedToday(for: programId)

        if let progress = WorkoutProgressManager.shared.getProgress(for: programId) {
            totalExercises = max(1, progress.totalExercises)
            isThemeCompleted = progress.isCompleted

            if progress.isCompleted {
                currentIndex = totalExercises
                progressFraction = 1
            } else {
                currentIndex = min(max(progress.currentExerciseIndex, 0), totalExercises)
                progressFraction = CGFloat(currentIndex) / CGFloat(totalExercises)
                progressFraction = min(max(progressFraction, 0), 1)
            }
        } else {
            isThemeCompleted = false
            totalExercises = 10
            currentIndex = 0
            progressFraction = 0
        }
    }
    
    func colorForCategory(_ colorName: String) -> Color {
        switch colorName {
        case "pastelPink": return Color(red: 1.0, green: 0.82, blue: 0.89)
        case "pastelBlue": return Color(red: 0.82, green: 0.89, blue: 1.0)
        case "pastelGreen": return Color(red: 0.85, green: 1.0, blue: 0.85)
        case "pastelYellow": return Color(red: 1.0, green: 1.0, blue: 0.75)
        case "pastelPurple": return Color(red: 0.95, green: 0.82, blue: 1.0)
        case "pastelOrange": return Color(red: 1.0, green: 0.9, blue: 0.78)
        case "pastelMint": return Color(red: 0.85, green: 1.0, blue: 0.95)
        default: return Color.gray
        }
    }
}
