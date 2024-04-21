//
//  LocalStorage.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 20.4.24.
//

import Foundation

class LocalStorageImpl: LocalStorage {
    private let keyUserName = "userName"
    private let keyUserAvatar = "userAvatar"
    private let keyGameNavigationType = "gameNavigationType"
    
    func saveUserName(_ name: String) {
        UserDefaults.standard.set(name, forKey: keyUserName)
    }
    
    func getUserName() -> String? {
        return UserDefaults.standard.string(forKey: keyUserName)
    }
    
    func saveUserAvatar(_ avatar: Data) {
        UserDefaults.standard.set(avatar, forKey: keyUserAvatar)
    }
    
    func getUserAvatar() -> Data? {
        return UserDefaults.standard.data(forKey: keyUserAvatar)
    }
    
    func saveGameNavigationType(_ gameNavType: String) {
        UserDefaults.standard.set(gameNavType, forKey: keyGameNavigationType)
    }
    
    func getGameNavigationType() -> String? {
        return UserDefaults.standard.string(forKey: keyGameNavigationType)
    }
}
