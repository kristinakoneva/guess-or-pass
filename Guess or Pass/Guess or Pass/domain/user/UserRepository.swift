//
//  UserRepository.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 20.4.24.
//

import Foundation

protocol UserRepository {
    func saveUserName(_ name: String)
    func getUserName() -> String?
    func saveUserAvatar(_ avatar: Data)
    func getUserAvatar() -> Data?
    func saveGameNavigationType(_ gameNavType: GameNavigationType)
    func getGameNavigationType() -> GameNavigationType
    func saveBestScore(_ bestScore: Int)
    func getBestScore() -> Int?
}
