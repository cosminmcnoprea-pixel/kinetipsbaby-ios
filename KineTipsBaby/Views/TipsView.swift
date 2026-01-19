//
//  TipsView.swift
//  KineTipsBaby
//
//  Created on 2026
//

import SwiftUI

struct TipsView: View {
    let tips = [
        Tip(title: "Tummy Time", description: "Start with short sessions of 3-5 minutes, several times a day. Always supervise and stop if baby shows distress.", icon: "figure.mind.and.body", color: .blue),
        Tip(title: "Safe Environment", description: "Ensure a clean, soft surface for exercises. Remove any hazards and keep the area comfortable.", icon: "shield.checkmark.fill", color: .green),
        Tip(title: "Follow Baby's Cues", description: "Watch for signs of tiredness or overstimulation. It's okay to stop and try again later.", icon: "eye.fill", color: .purple),
        Tip(title: "Consistency", description: "Regular practice helps development. Try to incorporate exercises into your daily routine.", icon: "calendar", color: .orange),
        Tip(title: "Consult Professional", description: "Always consult your pediatrician before starting any exercise program with your baby.", icon: "stethoscope", color: .red)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    Text("Helpful Tips")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    ForEach(tips) { tip in
                        TipCard(tip: tip)
                    }
                }
                .padding()
            }
            .background(Color(red: 0.1, green: 0.1, blue: 0.1))
            .navigationTitle("Tips")
        }
    }
}

struct Tip: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let color: Color
}

struct TipCard: View {
    let tip: Tip
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: tip.icon)
                .font(.system(size: 30))
                .foregroundColor(tip.color)
                .frame(width: 50)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(tip.title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(tip.description)
                    .font(.body)
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(red: 0.15, green: 0.15, blue: 0.15))
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
}
