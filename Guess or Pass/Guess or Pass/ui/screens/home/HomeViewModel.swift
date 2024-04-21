//
//  HomeViewModel.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 20.4.24.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var userName: String?
    @Published var userAvatar: UIImage?
    @Published var showAlert = false
    @Published var selectedCategory: WordsCategory? = nil
    
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
    
    func onPlayButtonClicked(){
        if selectedCategory == nil {
            showAlert = true
        } else {
            showAlert = false
        }
    }
}
