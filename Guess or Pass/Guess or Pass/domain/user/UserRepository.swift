//
//  UserRepository.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 20.4.24.
//

import Foundation

protocol UserRepository {
    func saveUserName(_ name: String)
    func getUsername() -> String?
}
