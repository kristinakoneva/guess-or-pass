//
//  SettingsScreen.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 21.4.24.
//

import SwiftUI

struct SettingsScreen: View {
    @ObservedObject var viewModel: SettingsViewModel = DependencyContainer.shared.resolve(SettingsViewModel.self)!

    var body: some View {
        ScrollView {
                HStack {
                    if let avatar = viewModel.avatar {
                        Image(uiImage: avatar)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    }
                    
                    if let name = viewModel.name {
                        Text(name)
                            .font(.title)
                            .padding()
                    }
                    Spacer()
                }
                
                if let bestScore = viewModel.bestScore {
                    Text("Best Score: \(bestScore)")
                        .font(.headline)
                        .padding()
                }
                
                VStack {
                    ForEach(viewModel.settingsItems, id: \.self) { item in
                        SettingsListItem(iconName: item.iconName, text: item.title, action: {
                            viewModel.onSettingsActionClicked(action: item.action)
                        })
                    }
                }.padding(.top, 32)
            }
        .padding(.horizontal, 32)
    }
}

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
    }
}

#Preview {
    SettingsScreen()
}
