//
//  InstructionsSheet.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 23.4.24.
//

import SwiftUI

struct InstructionsSheet: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Welcome to 'Guess or Pass,' a thrilling multiplayer game designed for word enthusiasts! 🤩")
                    .font(.title)
                
                Text("In this game, one lucky individual takes on the role of the guesser, while others act as the clue-givers, providing hints to help the guesser identify the correct word. 🧐 Now, let's dive into how you can navigate through this exciting adventure. 😄")
                    .padding(.bottom, 20)
                
                Text("Firstly, let's talk about navigation. 🧭 You have two options: buttons or motion. If you prefer the classic approach, opt for buttons. With this approach, we recommend that the person/people providing clues handle/s the navigation to prevent the guesser from accidentally seeing the next word. 🫣")
                    .padding(.bottom, 20)
                
                Text("Alternatively, if you're up for a more dynamic experience, try motion navigation. 🤪 In this mode, the guesser holds the phone with the back facing them. To signify a correct guess ✅, simply tilt the phone forward. Conversely, a backward tilt indicates that it's time to pass on to the next word. ⏭️")
                    .padding(.bottom, 20)
                
                Text("Now, let's discuss the gameplay. 🤔 You have a total of one minute to guess as many words as you can from the selected category. It's a race against time, so keep your wits about you and make each guess count! ⏳ Gather your friends, choose your preferred navigation method, and get ready for a word-guessing adventure with 'Guess or Pass' 🏁")
                    .padding(.bottom, 20)
            }
            .padding()
        }
    }
}


#Preview {
    InstructionsSheet()
}
