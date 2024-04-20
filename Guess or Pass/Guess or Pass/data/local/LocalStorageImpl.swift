//
//  LocalStorage.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 20.4.24.
//

import Foundation

class LocalStorageImpl: LocalStorage {
    private let userNameKey = "userName"
    
    func saveUserName(_ name: String) {
        UserDefaults.standard.set(name, forKey: userNameKey)
    }
    
    func getUserName() -> String? {
        return UserDefaults.standard.string(forKey: userNameKey)
    }
}
