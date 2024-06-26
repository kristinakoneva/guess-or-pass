//
//  SettingsScreen.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 21.4.24.
//

import SwiftUI

struct SettingsScreen: View {
    @EnvironmentObject var router: Router
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
                }, onDismiss: { viewModel.closeSheet() })
            case .instructions:
                InstructionsSheet(onDismiss: { viewModel.closeSheet() })
            case .galleryImagePicker:
                ImagePicker(selectedImage: $selectedImage, sourceType: .photoLibrary)
            case .cameraImagePicker:
                ImagePicker(selectedImage: $selectedImage, sourceType: .camera)
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
        .alert(isPresented: $viewModel.isCameraPermissionDeniedAlertPresented) {
            Alert(title: Text("Camera permission denied"), message: Text("If you want to take a photo with your camera and set it as your avatar, you will have to grant the camera permission in the settings."), dismissButton: .default(Text("OK"), action: { viewModel.closeAlertDialog() }))
        }
        .onReceive(viewModel.$navigateToSetReminder) { navigateToSetReminder in
            if navigateToSetReminder {
                viewModel.clearNavigationEvent()
                router.navigate(to: .reminder)
            }
        }
        .padding(.horizontal, 32)
        .navigationBarTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func showGameNavTypeActionSheet() -> ActionSheet{
        return ActionSheet(title: Text("Choose game navigation type"), buttons: [
            .default(Text("Button clicks")) { viewModel.saveGameNavTypeChoice(navType: GameNavigationType.buttons) },
            .default(Text("Swipe gestures")) { viewModel.saveGameNavTypeChoice(navType: GameNavigationType.swipes) },
            .default(Text("Phone tilting")) { viewModel.saveGameNavTypeChoice(navType: GameNavigationType.tilts) },
            .default(Text("Enable all")) { viewModel.saveGameNavTypeChoice(navType: GameNavigationType.all) },
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
