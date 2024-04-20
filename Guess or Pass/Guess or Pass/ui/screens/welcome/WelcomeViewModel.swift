//
//  WelcomeViewModel.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 20.4.24.
//

import Foundation

class WelcomeViewModel: ObservableObject {
    private let userRepository: UserRepository
    
    @Published var nameInput: String = ""
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func saveName() {
        userRepository.saveUserName(nameInput)
    }
    func saveUserAvatar(imageData: Data){
        // TODO
    }
}

