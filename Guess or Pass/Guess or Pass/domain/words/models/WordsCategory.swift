//
//  File.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 20.4.24.
//

import Foundation

enum WordsCategory: Codable {
    case animals
    case food
    case sports
    case technology
    case music
    case nature
    
    var categoryName: String {
        switch self {
        case .animals:
            return "Animals"
        case .food:
            return "Food"
        case .sports:
            return "Sports"
        case .technology:
            return "Technology"
        case .music:
            return "Music"
        case .nature:
            return "Nature"
        }
    }
    
    var imageName: String {
        switch self {
        case .animals:
            return "pawprint.fill"
        case .food:
            return "fork.knife"
        case .sports:
            return "figure.run"
        case .technology:
            return "macbook.and.iphone"
        case .music:
            return "music.note"
        case .nature:
            return "leaf.fill"
        }
    }
}
