//
//  SettingsScreen.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 21.4.24.
//

import SwiftUI

struct SettingsScreen: View {
    @ObservedObject var viewModel: SettingsViewModel = DependencyContainer.shared.resolve(SettingsViewModel.self)!
    @State private var selectedImage: UIImage?
    
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
        .sheet(isPresented: $viewModel.isSheetPresented, onDismiss: {
            if viewModel.settingsSheet == .galleryImagePicker || viewModel.settingsSheet == .cameraImagePicker {
                viewModel.saveNewAvatar(newAvatar: selectedImage)
                selectedImage = nil
            }
            viewModel.closeSheet()
        }) {
            switch viewModel.settingsSheet {
            case .nameChange:
                NameChangeSheet(newName: $viewModel.name, onSuccess: {
                    newName in viewModel.saveNewName(newName: newName)
                })
            case .instructions:
                InstructionsSheet()
            case .galleryImagePicker:
                ImagePicker(selectedImage: $selectedImage, sourceType: .photoLibrary)
            case .cameraImagePicker:
                ImagePicker(selectedImage: $selectedImage, sourceType: .camera)
            case .setReminder:
                VStack {}
            case .none:
                VStack {}
            }
        }
        .actionSheet(isPresented: $viewModel.isActionSheetPresented, content: {
            switch viewModel.settingsActionSheet {
            case .gameNavType:
                showGameNavTypeActionSheet()
            case .avatarChange:
                showAvatarChangeActionSheet()
            case .none:
                showGameNavTypeActionSheet()
            }
        })
    }
    
    func showGameNavTypeActionSheet() -> ActionSheet{
        return ActionSheet(title: Text("Choose game navigation type"), buttons: [
            .default(Text("Button clicks")) { viewModel.saveGameNavTypeChoice(navType: GameNavigationType.buttons) },
            .default(Text("Phone tilting")) { viewModel.saveGameNavTypeChoice(navType: GameNavigationType.tilt) },
            .default(Text("Both buttons and tilts")) { viewModel.saveGameNavTypeChoice(navType: GameNavigationType.all) },
            .cancel {
                viewModel.closeActionSheet()
            }
        ])
    }
    
    func showAvatarChangeActionSheet() -> ActionSheet {
        return ActionSheet(title: Text("Change avatar"), buttons: [
            .default(Text("Choose photo from gallery")) {
                viewModel.openImagePicker(sourceType:.photoLibrary)
            },
            .default(Text("Take a photo")) {
                viewModel.openImagePicker(sourceType:.camera)
            },
            .cancel {
                viewModel.closeActionSheet()
            }
        ])
    }
}

#Preview {
    SettingsScreen()
}
