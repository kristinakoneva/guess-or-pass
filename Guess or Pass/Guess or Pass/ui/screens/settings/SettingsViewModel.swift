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
    @Published private(set) var isNameChangeSheetShown = false
    @Published private(set) var isInstructionsSheetShown = false
    
    
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
            self.isSheetPresented = true
            self.isNameChangeSheetShown = true
            break
        case .changeAvatar:
            // Handle change avatar action
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
    
    func closeSheet() {
        self.isSheetPresented = false
        self.isNameChangeSheetShown = false
        self.isInstructionsSheetShown = false
    }
    
    func closeActionSheet() {
        self.isActionSheetPresented = false
        self.isGameNavTypeActionSheetShown = false
    }
}
