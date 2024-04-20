//
//  DatamuseApiSource.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 20.4.24.
//
import Foundation

protocol DatamuseApiSource {
    func fetchWords(for category: WordsCategoryRequest, completion: @escaping (Result<[String], Error>) -> Void)
}
