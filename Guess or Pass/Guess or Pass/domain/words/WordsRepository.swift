//
//  WordsRepository.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 20.4.24.
//

import Foundation

protocol WordsRepository {
    func fetchWords(for category: WordsCategory, completion: @escaping (Result<[String], Error>) -> Void)
}
