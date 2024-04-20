//
//  WordsCategory.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 20.4.24.
//

enum WordsCategoryRequest {
    case animals
    case food
    
    var topic: String {
        switch self {
        case .animals:
            return "animals,zoo,pets"
        case .food:
            return "food,meals"
        }
    }
    
    var exampleWord: String {
        switch self {
        case .animals:
            return "dog"
        case .food:
            return "pizza"
        }
    }
}
