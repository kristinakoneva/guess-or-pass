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
    
    @Published var showGameEndDialog: Bool = false
   
    private var words: [String] = []
    private var currentWordIndex: Int = 0
    
    private let wordsRepository: WordsRepository

    init(wordsRepository: WordsRepository) {
        self.wordsRepository = wordsRepository
        fetchWords(for: WordsCategory.animals)
        currentWord = words[currentWordIndex]
    }

    private func fetchWords(for category: WordsCategory) {
        words = ["Word1", "Word2", "Word3", "Word4", "Word5"]
    }

    func passWord() {
        backgroundColor = .red
        
        var blinked = false
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { timer in
            if !blinked {
                blinked = true
                timer.invalidate()
                self.backgroundColor = .blue
                self.nextWord()
            }
        }
    }

    func guessWord() {
        guessedWordsCount += 1
        backgroundColor = .green
        
        var blinked = false
        Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { timer in
            if !blinked {
                blinked = true
                timer.invalidate()
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
    }

    func endGame() {
        showGameEndDialog = true
    }
 }
