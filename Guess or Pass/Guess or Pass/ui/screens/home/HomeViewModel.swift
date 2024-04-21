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
    @Published private(set) var showNoCategorySelectedDialog = false
    @Published private(set) var showGameStartDialog = false
    @Published private(set) var selectedCategory: WordsCategory? = nil
    @Published var showDialog = false
    
    private let userRepository: UserRepository
    private let wordsRepository: WordsRepository
    
    var categories: [WordsCategory] = [.animals, .food, .sports, .technology, .music, .nature]
    
    init(userRepository: UserRepository, wordsRepository: WordsRepository) {
        self.userRepository = userRepository
        self.wordsRepository = wordsRepository
        
        fetchUserData()
    }
    
    private func fetchUserData() {
        self.userName = userRepository.getUserName()
        self.userAvatar = UIImage(data: userRepository.getUserAvatar()!)
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
