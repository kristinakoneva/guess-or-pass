//
//  GameScreen.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 21.4.24.
//

import SwiftUI

struct GameScreen: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var orientationInfo: OrientationInfo
    @ObservedObject var viewModel: GameViewModel = DependencyContainer.shared.resolve(GameViewModel.self)!

    @State private var isCountdownFinished = false

    var body: some View {
        VStack {
            if isCountdownFinished {
                VStack {
                    Text("Time Left: \(viewModel.timeLeft)")
                        .font(.title)
                        .padding(.trailing, 20)
                        .padding(.top, 20)

                    Text(viewModel.currentWord)
                        .font(.largeTitle)
                        .padding()

                    HStack {
                        Button("Pass", action: {
                            viewModel.passWord()
                            //viewModel.nextWord()
                        })
                        .padding()

                        Spacer()

                        Button("Guessed", action: {
                            viewModel.guessWord()
                            //viewModel.nextWord()
                        })
                        .padding()
                    }
                    .padding(.horizontal)
                }
                .background(viewModel.backgroundColor)
                .alert(isPresented: $viewModel.showGameEndDialog) {
                    Alert(title: Text("Game Over"), message: Text("You guessed \(viewModel.guessedWordsCount) words!"), dismissButton: .default(Text("OK")))
                }
            } else {
                CountdownView() {
                    isCountdownFinished = true
                }
            }
        }
    }
}

struct CountdownView: View {
    var onFinish: () -> Void
    @State var countdown: Int = 5

    var body: some View {
        ZStack {
            Color.yellow
                .edgesIgnoringSafeArea(.all)

            Text("\(countdown)")
                .font(.system(size: 100, weight: .bold))
                .foregroundColor(.black)
                .onAppear {
                    startCountdown()
                }
        }
    }

    private func startCountdown() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if countdown > 1 {
                countdown -= 1
            } else {
                timer.invalidate()
                onFinish()
            }
        }
    }
}
