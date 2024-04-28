//
//  Guess_or_PassApp.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 20.4.24.
//

import SwiftUI
import CoreMotion

@main
struct Guess_or_PassApp: App {
    @ObservedObject var router = Router()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.navPath) {
                VStack{}
                    .navigationDestination(for: Router.Destination.self) { destination in
                        switch destination {
                        case .welcome:
                            WelcomeScreen().navigationBarBackButtonHidden(true)
                        case .home:
                            HomeScreen().navigationBarBackButtonHidden(true)
                        case .game(let wordsCategory, let gameNavType):
                            GameScreen(wordsCategory: wordsCategory, gameNavType: gameNavType).navigationBarBackButtonHidden(true)
                        case .settings:
                            SettingsScreen().environmentObject(OrientationInfo())
                        case .reminder:
                            ReminderScreen()
                        }
                    }
            }
            .environmentObject(router)
            .onAppear {
                router.navigate(to: .welcome)
            }
        }
    }
}
