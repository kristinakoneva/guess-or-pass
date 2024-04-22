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
                
                Text(viewModel.name)
                    .font(.title)
                    .padding()
                
                Spacer()
            }
            
            if let bestScore = viewModel.bestScore {
                HStack {
                    Text("Best score 💪: \(bestScore) words/min")
                        .font(.headline)
                        .padding()
                    Spacer()
                }
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
        .sheet(isPresented: $viewModel.isSheetPresented) {
            if viewModel.isNameChangeSheetShown {
                NameChangeSheet(newName: $viewModel.name, onSuccess: {
                    newName in viewModel.saveNewName(newName: newName)
                })
            }
            // TODO: Implement other sheets
            
        }
        .actionSheet(isPresented: $viewModel.isActionSheetPresented, content: {
            if viewModel.isGameNavTypeSheetShown {
                return ActionSheet(title: Text("Choose game navigation type"), buttons: [
                    .default(Text("Button clicks")) { viewModel.saveGameNavTypeChoice(navType: GameNavigationType.buttons) },
                    .default(Text("Phone tilting")) { viewModel.saveGameNavTypeChoice(navType: GameNavigationType.tilt) },
                    .default(Text("Both buttons and tilts")) { viewModel.saveGameNavTypeChoice(navType: GameNavigationType.all) },
                    .cancel()
                ])
            }
            // TODO: Implement other sheets
            return ActionSheet(title: Text("Choose game navigation type"), buttons: [
                .default(Text("Button clicks")) { },
                .default(Text("Phone tilting")) {  },
                .default(Text("Both buttons and tilts")) { },
                .cancel()
            ])
            
        })
    }
}

#Preview {
    SettingsScreen()
}
