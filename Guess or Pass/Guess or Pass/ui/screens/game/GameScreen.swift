//
//  GameScreen.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 21.4.24.
//

import Foundation
import SwiftUI

struct GameScreen: View{
    
    @EnvironmentObject var router: Router
    @ObservedObject var viewModel: GameViewModel = DependencyContainer.shared.resolve(GameViewModel.self)!
    
    
    var body: some View {
        VStack{
            
        }
    }
}
