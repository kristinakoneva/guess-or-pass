//
//  SettingsListItem.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 22.4.24.
//

import Foundation
import SwiftUI

struct SettingsListItem: View {
    let iconName: String
    let text: String
    let action: () -> Void

    var body: some View {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.blue)
                Text(text)
                Spacer()
                Image(systemName: "chevron.compact.right")
                    .foregroundColor(.blue)
            }
            .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 3)
        .padding(.horizontal)
        .onTapGesture {
            action()
        }
    }
}
