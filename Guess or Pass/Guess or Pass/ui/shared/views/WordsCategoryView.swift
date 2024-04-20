//
//  WordsCategoryView.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 20.4.24.
//

import SwiftUI

struct WordsCategoryView: View {
    var category: WordsCategory
    @Binding var isSelected: Bool
    
    var body: some View {
        VStack {
            Image(systemName: category.imageName)
                .resizable()
                .frame(width: 50, height: 50)
                .padding()
                .background(isSelected ? Color.blue.opacity(0.3) : Color.clear)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                )
            
            Text(category.categoryName)
                .font(.caption)
                .padding(.bottom, 5)
        }
    }
}

