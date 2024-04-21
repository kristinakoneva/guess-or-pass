//
//  GameViewModel.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 21.4.24.
//

import Foundation

class GameViewModel: ObservableObject {
    
    private let wordsRepository: WordsRepository
    
    init(wordsRepository: WordsRepository) {
        self.wordsRepository = wordsRepository
    }
}
