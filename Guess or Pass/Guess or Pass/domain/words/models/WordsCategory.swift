//
//  File.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 20.4.24.
//

enum WordsCategory {
    case animals
    case food
    
    var categoryName: String {
        switch self {
        case .animals:
            return "Animals"
        case .food:
            return "Food"
        }
    }
    
    var imageName: String {
        switch self {
        case .animals:
            return "pawprint.fill"
        case .food:
            return "fork.knife"
        }
    }
}
