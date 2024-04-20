//
//  WelcomeScreen.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 20.4.24.
//

import SwiftUI

struct WelcomeScreen: View {
    @ObservedObject var viewModel: WelcomeViewModel = DependencyContainer.shared.resolve(WelcomeViewModel.self)!
    
    var body: some View {
        VStack {
            Text("Welcome")
                .font(.largeTitle)
                .padding()
            
            TextField("Enter your name", text: $viewModel.nameInput)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Save") {
                viewModel.saveName()
                // Navigate to another screen here
            }
            .padding()
        }
        .padding()
    }
}
