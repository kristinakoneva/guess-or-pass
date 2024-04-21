//
//  UserRepositoryImpl.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 20.4.24.
//

import Foundation

class UserRepositoryImpl: UserRepository {
    
    private let localStorage: LocalStorage
    
    init(localStorage: LocalStorage) {
        self.localStorage = localStorage
    }
    
    func saveUserName(_ name: String) {
        localStorage.saveUserName(name)
    }
    
    func getUserName() -> String? {
        return localStorage.getUserName()
    }
    
    func saveUserAvatar(_ avatar: Data) {
        localStorage.saveUserAvatar(avatar)
    }
    
    func getUserAvatar() -> Data? {
        return localStorage.getUserAvatar()
    }
    
    func saveGameNavigationType(_ gameNavType: GameNavigationType) {
        localStorage.saveGameNavigationType(gameNavType.rawValue)
    }
    
    func getGameNavigationType() -> GameNavigationType? {
        return GameNavigationType(rawValue: localStorage.getGameNavigationType() ?? "all")
    }
}
