//
//  GameViewModel.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 21.4.24.
//

import Foundation
import SwiftUI

class GameViewModel: ObservableObject {
    @Published private(set) var isCountdownFinished = false
    @Published private(set) var currentWord: String = ""
    @Published private(set) var guessedWordsCount: Int = 0
    @Published private(set) var backgroundColor: Color = .yellow
    @Published private(set) var shouldObserveMotionUpdates = false
    
    @Published var showGameEndDialog: Bool = false
    
    private var words: [String] = []
    private var currentWordIndex: Int = 0
    
    private let wordsRepository: WordsRepository
    private let userRepository: UserRepository
    
    init(wordsRepository: WordsRepository, userRepository: UserRepository) {
        self.wordsRepository = wordsRepository
        self.userRepository = userRepository
    }
    
    func fetchWords(for category: WordsCategory) {
        wordsRepository.fetchWords(for: category) { result in
            switch result {
            case .success(let words):
                self.words = words
                self.filterAndShuffleWords()
                self.currentWord = self.words[self.currentWordIndex]
            case .failure(let error):
                print("Error fetching words:", error)
            }
        }
    }
    
    func passWord() {
        backgroundColor = .red
        shouldObserveMotionUpdates = false
        
        blink()
    }
    
    func guessWord() {
        guessedWordsCount += 1
        backgroundColor = .green
        shouldObserveMotionUpdates = false
        
        blink()
    }
    
    private func blink() {
        var blinked = false
        Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { timer in
            if !blinked {
                blinked = true
                timer.invalidate()
                self.shouldObserveMotionUpdates = true
                self.backgroundColor = .blue
                self.nextWord()
            }
        }
    }
    
    func nextWord() {
        currentWordIndex += 1
        if currentWordIndex >= words.count {
            endGame()
            return
        }
        currentWord = words[currentWordIndex]
    }
    
    func startGame() {
        self.backgroundColor = .blue
        isCountdownFinished = true
        shouldObserveMotionUpdates = true
    }
    
    func endGame() {
        showGameEndDialog = true
        let currentBestScore = userRepository.getBestScore()
        if currentBestScore == nil {
            userRepository.saveBestScore(guessedWordsCount)
        } else {
            if currentBestScore! < guessedWordsCount {
                userRepository.saveBestScore(guessedWordsCount)
            }
        }
        shouldObserveMotionUpdates = false
    }
    
    func filterAndShuffleWords() {
        var filteredWords: [String] = []
        
        for word in words {
            let singularForm = word.singularForm()
            if !filteredWords.contains(singularForm) {
                filteredWords.append(singularForm)
            }
        }
        
        words =  filteredWords.shuffled()
    }
}
