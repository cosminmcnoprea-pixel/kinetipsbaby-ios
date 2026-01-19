//
//  BabyExercise.swift
//  KineTipsBaby
//
//  Created on 2026
//

import Foundation

struct BabyExercise: Identifiable, Codable {
    let id = UUID()
    let exerciseName: String
    let exerciseDescription: String
    let detailedInstructions: String
    let environmentSetup: String
    let parentTips: String
    let thumbnailName: String
    let videoURL: String?
    let durationSeconds: Int
    let repetitions: Int
    let ageRangeMonthsMin: Int
    let ageRangeMonthsMax: Int
    
    var isTimedExercise: Bool {
        return durationSeconds > 0
    }
    
    var isCountBasedExercise: Bool {
        return repetitions > 0
    }
    
    var ageRangeText: String {
        return "\(ageRangeMonthsMin)-\(ageRangeMonthsMax) months"
    }
    
    var durationText: String {
        if isTimedExercise {
            return "\(durationSeconds)s"
        } else if isCountBasedExercise {
            return "\(repetitions) reps"
        }
        return ""
    }
}

struct BabyProgram: Identifiable, Codable {
    let id = UUID()
    let programId: String
    let categoryId: String
    let themeSlug: String
    let themeTitle: String
    let themeHint: String
    let exercises: [BabyExercise]
    let ageRangeMin: Int
    let ageRangeMax: Int
    
    var ageRangeText: String {
        return "\(ageRangeMin)-\(ageRangeMax) months"
    }
}

struct BabyCategory: Identifiable {
    let id = UUID()
    let categoryId: String
    let title: String
    let ageRangeMin: Int
    let ageRangeMax: Int
    let icon: String
    let color: String
    
    var ageRangeText: String {
        return "\(ageRangeMin)-\(ageRangeMax) months"
    }
}
