//
//  WorkoutProgressManager.swift
//  KineTipsBaby
//
//  Created on 2026
//

import Foundation

extension Notification.Name {
    static let workoutProgressDidChange = Notification.Name("workoutProgressDidChange")
}

struct WorkoutProgress: Codable {
    let programId: String
    let currentExerciseIndex: Int
    let totalExercises: Int
    let isCompleted: Bool
    let lastUpdated: Date
    let completedToday: Int
    let lastCompletionDate: Date?
}

struct TodayProgressStats {
    let exercisesCompleted: Int
    let totalMinutes: Int
    let themesCompleted: Int
}

class WorkoutProgressManager {
    static let shared = WorkoutProgressManager()
    private let userDefaults = UserDefaults.standard
    private let progressKey = "workout_progress"
    private let calendar = Calendar.current
    
    private init() {}
    
    func saveProgress(programId: String, currentIndex: Int, totalExercises: Int, isCompleted: Bool) {
        let now = Date()
        var allProgress = getAllProgress()
        let existingProgress = allProgress[programId]
        
        // Check if we need to reset daily count (new day)
        var completedToday = existingProgress?.completedToday ?? 0
        var lastCompletionDate = existingProgress?.lastCompletionDate
        
        if let lastDate = lastCompletionDate {
            if !calendar.isDate(lastDate, inSameDayAs: now) {
                // New day - reset count
                completedToday = 0
            }
        }
        
        // If this is a completion, increment today's count
        if isCompleted && (existingProgress?.isCompleted == false || existingProgress == nil) {
            completedToday += 1
            lastCompletionDate = now
        }
        
        let progress = WorkoutProgress(
            programId: programId,
            currentExerciseIndex: currentIndex,
            totalExercises: totalExercises,
            isCompleted: isCompleted,
            lastUpdated: now,
            completedToday: completedToday,
            lastCompletionDate: lastCompletionDate
        )
        
        allProgress[programId] = progress
        
        if let encoded = try? JSONEncoder().encode(allProgress) {
            userDefaults.set(encoded, forKey: progressKey)
        }

        NotificationCenter.default.post(
            name: .workoutProgressDidChange,
            object: nil,
            userInfo: ["programId": programId]
        )
    }
    
    func getProgress(for programId: String) -> WorkoutProgress? {
        let allProgress = getAllProgress()
        return allProgress[programId]
    }
    
    func clearProgress(for programId: String) {
        var allProgress = getAllProgress()
        allProgress.removeValue(forKey: programId)
        
        if let encoded = try? JSONEncoder().encode(allProgress) {
            userDefaults.set(encoded, forKey: progressKey)
        }

        NotificationCenter.default.post(
            name: .workoutProgressDidChange,
            object: nil,
            userInfo: ["programId": programId]
        )
    }
    
    func getProgressPercentage(for programId: String) -> Double {
        guard let progress = getProgress(for: programId) else { return 0.0 }
        if progress.isCompleted { return 1.0 }
        return Double(progress.currentExerciseIndex) / Double(progress.totalExercises)
    }
    
    func getCompletedToday(for programId: String) -> Int {
        guard let progress = getProgress(for: programId) else { return 0 }
        
        // Check if the last completion was today
        if let lastDate = progress.lastCompletionDate {
            if calendar.isDate(lastDate, inSameDayAs: Date()) {
                return progress.completedToday
            }
        }
        
        return 0
    }

    func getTodayStats() -> TodayProgressStats {
        let now = Date()
        let allProgress = getAllProgress()

        var exercisesCompleted = 0
        var themesCompleted = 0

        for progress in allProgress.values {
            // Count exercises only for sessions touched today
            if calendar.isDate(progress.lastUpdated, inSameDayAs: now) {
                let completedExercises = progress.isCompleted ? progress.totalExercises : progress.currentExerciseIndex
                exercisesCompleted += max(0, min(completedExercises, progress.totalExercises))
            }

            // Count completed themes for today
            if progress.isCompleted,
               let completionDate = progress.lastCompletionDate,
               calendar.isDate(completionDate, inSameDayAs: now) {
                themesCompleted += 1
            }
        }

        // Estimated minutes: treat each exercise as ~1 minute (timed+rep based blended).
        let totalMinutes = max(0, exercisesCompleted)

        return TodayProgressStats(
            exercisesCompleted: exercisesCompleted,
            totalMinutes: totalMinutes,
            themesCompleted: themesCompleted
        )
    }
    
    private func getAllProgress() -> [String: WorkoutProgress] {
        guard let data = userDefaults.data(forKey: progressKey),
              let decoded = try? JSONDecoder().decode([String: WorkoutProgress].self, from: data) else {
            return [:]
        }
        return decoded
    }
}
