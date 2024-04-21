//
//  WordsCategory.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 20.4.24.
//

enum WordsCategoryRequest {
    case animals
    case food
    case sports
    case technology
    case music
    case nature
    
    var topic: String {
        switch self {
        case .animals:
            return "animals,zoo,pets"
        case .food:
            return "food,meals"
        case .sports:
            return "sports,games,fitness"
        case .technology:
            return "technology,gadgets"
        case .music:
            return "music,instruments"
        case .nature:
            return "nature,environment,outdoors"
        }
    }
    
    var exampleWord: String {
        switch self {
        case .animals:
            return "dog"
        case .food:
            return "pizza"
        case .sports:
            return "football"
        case .technology:
            return "smartphone"
        case .music:
            return "guitar"
        case .nature:
            return "tree"
        }
    }
}
