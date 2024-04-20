//
//  DatamuseApiSourceImpl.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 20.4.24.
//

import Alamofire

class DatamuseApiSourceImpl: DatamuseApiSource {
    private let baseUrl = "https://api.datamuse.com/words"
    
    func fetchWords(for category: WordsCategoryRequest, completion: @escaping (Result<[String], Error>) -> Void) {
        let parameters: [String: Any] = [
            "ml": category.exampleWord,
            "topics": category.topic,
            "max": 1000
        ]
        
        AF.request(baseUrl, parameters: parameters).responseDecodable(of: [DatamuseWord].self) { response in
            switch response.result {
            case .success(let words):
                let wordStrings = words.map { $0.word }
                completion(.success(wordStrings))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
