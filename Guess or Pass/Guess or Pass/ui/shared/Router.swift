//
//  Router.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 20.4.24.
//

import SwiftUI

final class Router: ObservableObject {
    
    public enum Destination: Codable, Hashable {
        case welcome
        case home
    }
    
    @Published var navPath = NavigationPath()
    
    func navigate(to destination: Destination) {
        navPath.append(destination)
    }
    
    func navigateBack() {
        navPath.removeLast()
    }
    
    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
}
