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
    
    @Published var navigateToSetReminder = false
    
    @Published private(set) var settingsActionSheet: SettingsActionSheet? = nil
    @Published private(set) var settingsSheet: SettingsSheet? = nil
    @Published var isActionSheetPresented = false
    @Published var isSheetPresented = false
    
    let settingsItems: [SettingsItem] = [
        .changeName,
        .changeAvatar,
        .readInstructions,
        .changeGameNavigation,
        .setReminder
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
            self.settingsSheet = .nameChange
            self.isSheetPresented = true
            break
        case .changeAvatar:
            self.settingsActionSheet = .avatarChange
            self.isActionSheetPresented = true
            break
        case .changeGameNavigation:
            self.settingsActionSheet = .gameNavType
            self.isActionSheetPresented = true
            break
        case .readInstructions:
            self.settingsSheet = .instructions
            self.isSheetPresented = true
            break
        case .setReminder:
            self.navigateToSetReminder = true
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
        settingsSheet = nil
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
            settingsSheet = .galleryImagePicker
        } else {
            settingsSheet = .cameraImagePicker
        }
        isSheetPresented = true
    }
    
    func closeSheet() {
        self.isSheetPresented = false
        self.settingsSheet = nil
    }
    
    func closeActionSheet() {
        self.isActionSheetPresented = false
        self.settingsActionSheet = nil
    }
    
    func clearNavigationEvent() {
        self.navigateToSetReminder = false
    }
}
