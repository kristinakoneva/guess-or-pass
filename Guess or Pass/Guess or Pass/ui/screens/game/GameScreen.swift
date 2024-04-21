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
    var wordsCategory: WordsCategory
    @ObservedObject var viewModel: GameViewModel = DependencyContainer.shared.resolve(GameViewModel.self)!
    
    @State private var timeLeft = 60
    @State private var timer: Timer? = nil
    
    var body: some View {
        Group {
            if viewModel.isCountdownFinished {
                VStack {
                    viewModel.backgroundColor
                        .edgesIgnoringSafeArea(.all)
                    
                    Text("Time Left: \(timeLeft)")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.trailing, 20)
                        .padding(.top, 16).onAppear {
                            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                                if timeLeft > 1 {
                                    timeLeft -= 1
                                } else {
                                    timer.invalidate()
                                    viewModel.endGame()
                                }
                            }
                        }
                    
                    Text(viewModel.currentWord)
                        .font(.largeTitle)
                        .foregroundColor(Color.white)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding()
                    
                    HStack {
                        Button("Pass", action: {
                            viewModel.passWord()
                        })
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        
                        Spacer()
                        
                        Button("Guessed", action: {
                            viewModel.guessWord()
                        })
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                .background(viewModel.backgroundColor)
                .alert(isPresented: $viewModel.showGameEndDialog) {
                    timer?.invalidate()
                    return Alert(title: Text("Game Over"), message: Text("You guessed \(viewModel.guessedWordsCount) words!"), dismissButton: .default(Text("OK"),action: {
                        router.navigateBack()
                    }))
                }
            } else {
                CountdownView() {
                    viewModel.startGame()
                }
            }
        }.onAppear {
            viewModel.fetchWords(for: self.wordsCategory)
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

#Preview {
    GameScreen(wordsCategory: WordsCategory.animals)
}
