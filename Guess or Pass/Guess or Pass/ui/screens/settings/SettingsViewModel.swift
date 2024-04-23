//
//  SettingsViewModel.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 21.4.24.
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    private let userRepository: UserRepository
    
    @Published var name: String = ""
    @Published private(set) var avatar: UIImage? = nil
    @Published private(set) var bestScore: Int? = nil
    @Published private(set) var isGameNavTypeActionSheetShown = false
    @Published private(set) var isAvatarChangeActionSheetShown = false
    @Published private(set) var isNameChangeSheetShown = false
    @Published private(set) var isInstructionsSheetShown = false
    @Published private(set) var isPhotoGalleryImagePickerShown = false
    @Published private(set) var isCameraImagePickerShown = false
    
    
    @Published var isActionSheetPresented = false
    @Published var isSheetPresented = false
    
    let settingsItems: [SettingsItem] = [
        .changeName,
        .changeAvatar,
        .changeGameNavigation,
        .readInstructions
    ]
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
        self.name = userRepository.getUserName() ?? ""
        self.avatar = UIImage(data: userRepository.getUserAvatar()!)
        self.bestScore = userRepository.getBestScore()
    }
    
    func onSettingsActionClicked(action: SettingsAction) {
        switch action {
        case .changeName:
            self.isNameChangeSheetShown = true
            self.isSheetPresented = true
            break
        case .changeAvatar:
            self.isAvatarChangeActionSheetShown = true
            self.isActionSheetPresented = true
            break
        case .changeGameNavigation:
            self.isGameNavTypeActionSheetShown = true
            self.isActionSheetPresented = true
            break
        case .readInstructions:
            self.isInstructionsSheetShown = true
            self.isSheetPresented = true
            break
        }
    }
    
    func saveGameNavTypeChoice(navType: GameNavigationType) {
        closeActionSheet()
        userRepository.saveGameNavigationType(navType)
    }
    
    func saveNewName(newName: String) {
        userRepository.saveUserName(newName)
        self.name = newName
        isSheetPresented = false
        isNameChangeSheetShown = false
    }
    
    func saveNewAvatar(newAvatar: UIImage?){
        if newAvatar != nil {
            userRepository.saveUserAvatar(newAvatar!.pngData()!)
            avatar = newAvatar
        }
        closeActionSheet()
    }
    
    func openImagePicker(sourceType: UIImagePickerController.SourceType) {
        if sourceType == .photoLibrary {
            isPhotoGalleryImagePickerShown = true
        } else {
            isCameraImagePickerShown = true
        }
        isSheetPresented = true
    }
    
    func closeSheet() {
        self.isSheetPresented = false
        self.isNameChangeSheetShown = false
        self.isInstructionsSheetShown = false
        self.isPhotoGalleryImagePickerShown = false
        self.isCameraImagePickerShown = false
    }
    
    func closeActionSheet() {
        self.isActionSheetPresented = false
        self.isGameNavTypeActionSheetShown = false
        self.isAvatarChangeActionSheetShown = false
    }
}
