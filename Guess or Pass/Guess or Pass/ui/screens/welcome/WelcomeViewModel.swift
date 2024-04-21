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
    @Published private(set) var isNewUser: Bool = true
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
        let name = userRepository.getUserName()
        let avatar = userRepository.getUserAvatar()
        if name != nil || avatar != nil {
            isNewUser = false
        }
    }
    
    func saveUserName() {
        userRepository.saveUserName(nameInput)
    }
    
    func saveUserAvatar(imageData: Data){
        userRepository.saveUserAvatar(imageData)
    }
}
