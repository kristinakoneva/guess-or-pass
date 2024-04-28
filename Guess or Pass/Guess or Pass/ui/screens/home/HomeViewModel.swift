//
//  HomeViewModel.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 20.4.24.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published private(set) var userName: String?
    @Published private(set) var userAvatar: UIImage?
    @Published private(set) var bestScore: Int? = nil
    @Published private(set) var gameNavType: GameNavigationType = GameNavigationType.all
    @Published private(set) var showNoCategorySelectedDialog = false
    @Published private(set) var showGameStartDialog = false
    @Published private(set) var selectedCategory: WordsCategory? = nil
    @Published var showDialog = false
    
    private let userRepository: UserRepository
    
    var categories: [WordsCategory] = [.animals, .food, .sports, .technology, .music, .nature]
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
        
        fetchUserData()
    }
    
    func fetchUserData() {
        self.userName = userRepository.getUserName()
        self.userAvatar = UIImage(data: userRepository.getUserAvatar()!)
        self.bestScore = userRepository.getBestScore()
        self.gameNavType = userRepository.getGameNavigationType()
    }
    
    func selectCategory(_ category: WordsCategory) {
        if selectedCategory == category {
            selectedCategory = nil
        } else {
            selectedCategory = category
        }
    }
    
    func onPlayButtonClicked() {
        showDialog = true
        if selectedCategory == nil {
            showGameStartDialog = false
            showNoCategorySelectedDialog = true
        } else {
            showNoCategorySelectedDialog = false
            showGameStartDialog = true
        }
    }
    
    func closeDialog() {
        showDialog = false
        showGameStartDialog = false
        showNoCategorySelectedDialog = false
    }
}
