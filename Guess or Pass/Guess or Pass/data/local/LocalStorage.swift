//
//  LocalStorageProtocol.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 20.4.24.
//

import Foundation

protocol LocalStorage {
    func saveUserName(_ name: String)
    func getUserName() -> String?
    func saveUserAvatar(_ avatar: Data)
    func getUserAvatar() -> Data?
}