//
//  Guess_or_PassApp.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 20.4.24.
//

import SwiftUI

@main
struct Guess_or_PassApp: App {
    @ObservedObject var router = Router()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.navPath) {
                WelcomeScreen()
                    .navigationDestination(for: Router.Destination.self) { destination in
                        switch destination {
                        case .welcome:
                            WelcomeScreen()
                        case .home:
                            HomeScreen().navigationBarBackButtonHidden(true)
                        case .game(let wordsCategory, let gameNavType):
                            GameScreen(wordsCategory: wordsCategory, gameNavType: gameNavType).navigationBarBackButtonHidden(true).environmentObject(OrientationInfo())
                        case .settings:
                            SettingsScreen()
                        }
                    }
            }
            .environmentObject(router)
        }
    }
}
