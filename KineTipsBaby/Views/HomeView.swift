//
//  HomeView.swift
//  KineTipsBaby
//
//  Created on 2026
//

import SwiftUI

struct HomeView: View {
    let categories = BabyExerciseDataGenerator.getAllCategories()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 12) {
                        Image(systemName: "heart.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.pink.opacity(0.7))
                            .padding(.top, 20)
                        
                        Text("KineTips Baby")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.primary)
                            .padding(.top)
                        
                        Text("Gentle exercises for your baby's development")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.bottom, 10)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(categories) { category in
                            NavigationLink(destination: ProgramListView(category: category)) {
                                CategoryCard(category: category)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 20)
            }
            .background(Color(red: 0.1, green: 0.1, blue: 0.1))
            .navigationTitle("Baby Programs")
            .navigationBarTitleDisplayModeInline()
        }
    }
}

struct CategoryCard: View {
    let category: BabyCategory
    
    var body: some View {
        VStack(spacing: 12) {
            Text(category.icon)
                .font(.system(size: 40))
            
            Text(category.title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            Text(category.ageRangeText)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .frame(height: 140)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(red: 0.15, green: 0.15, blue: 0.15))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(colorForCategory(category.color), lineWidth: 3)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
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
