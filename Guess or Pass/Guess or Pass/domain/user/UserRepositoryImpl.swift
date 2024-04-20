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
    
    func getUsername() -> String? {
        return localStorage.getUserName()
    }
}
