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
                    HomeScreen()
                    .navigationDestination(for: Router.Destination.self) { destination in
                        switch destination {
                        case .welcome:
                            HomeScreen()
                        case .home:
                            HomeScreen()
                        }
                    }
                }
                .environmentObject(router)
            }
        }
}
