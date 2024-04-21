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
    
    @Published private(set) var name: String? = nil
    @Published private(set) var avatar: UIImage? = nil
    @Published private(set) var bestScore: Int? = nil
    
    let settingsItems: [SettingsItem] = [
            .changeName,
            .changeAvatar,
            .changeGameNavigation,
            .readInstructions
        ]
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
        self.name = userRepository.getUserName()
        self.avatar = UIImage(data: userRepository.getUserAvatar()!)
    }

    func onSettingsActionClicked(action: SettingsAction) {
        switch action {
        case .changeName:
            // Handle change name action
            break
        case .changeAvatar:
            // Handle change avatar action
            break
        case .changeGameNavigation:
            // Handle change game navigation action
            break
        case .readInstructions:
            // Handle read instructions action
            break
        }
    }
}
