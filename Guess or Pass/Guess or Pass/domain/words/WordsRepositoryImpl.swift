//
//  WordsRepositoryImpl.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 20.4.24.
//

class WordsRepositoryImpl: WordsRepository {
    private let apiSource: DatamuseApiSource
    
    init(apiSource: DatamuseApiSource) {
        self.apiSource = apiSource
    }
    
    func fetchWords(for category: WordsCategory, completion: @escaping (Result<[String], Error>) -> Void) {
        let wordsCategoryRequest = mapToWordsCategoryRequest(category)
        apiSource.fetchWords(for: wordsCategoryRequest, completion: completion)
    }
    
    private func mapToWordsCategoryRequest(_ category: WordsCategory) -> WordsCategoryRequest {
           switch category {
           case .animals:
               return WordsCategoryRequest.animals
           case .food:
               return WordsCategoryRequest.food
           }
       }
}
