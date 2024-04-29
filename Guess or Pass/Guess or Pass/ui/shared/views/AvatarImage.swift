//
//  AvatarImage.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 29.4.24.
//
import SwiftUI

struct AvatarImage: View {
    var systemName: String
    var isSelected: Bool
    
    var body: some View {
        Image(systemName: systemName)
            .resizable()
            .frame(width: 50, height: 50)
            .padding()
            .background(isSelected ? Color.blue.opacity(0.3) : Color.clear)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
    }
}
