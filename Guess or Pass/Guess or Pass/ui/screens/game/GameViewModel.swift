//
//  GameViewModel.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 21.4.24.
//

import Foundation
import SwiftUI

class GameViewModel: ObservableObject {
    @Published private(set) var timeLeft: Int = 60
    @Published private(set) var words: [String] = []
    @Published private(set) var currentWord: String = ""
    @Published private(set) var guessedWordsCount: Int = 0
    @Published private(set) var backgroundColor: Color = .yellow
    @Published var showGameEndDialog: Bool = false
    private let wordsRepository: WordsRepository

    init(wordsRepository: WordsRepository) {
        self.wordsRepository = wordsRepository
        fetchWords(for: WordsCategory.animals)
        setCurrentWord("")
    }

    private func fetchWords(for category: WordsCategory) {
        // Use your WordsRepository to fetch words for the given category
        // For now, use a dummy list of words
        words = ["Word1", "Word2", "Word3", "Word4", "Word5"]
    }

    func updateTimeLeft(_ timeLeft: Int) {
        self.timeLeft = timeLeft
    }

    func setCurrentWord(_ word: String) {
        currentWord = word
    }

    func passWord() {
        // Handle passing word
        backgroundColor = .red // Show red background
    }

    func guessWord() {
        // Handle guessing word
        guessedWordsCount += 1
        backgroundColor = .green // Show green background
    }

    func endGame() {
        // End the game
        showGameEndDialog = true
    }
}
