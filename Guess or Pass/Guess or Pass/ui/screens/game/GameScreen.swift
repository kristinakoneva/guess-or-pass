//
//  GameScreen.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 21.4.24.
//

import SwiftUI
import Foundation
import CoreMotion

struct GameScreen: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var orientationInfo: OrientationInfo
    var wordsCategory: WordsCategory
    var gameNavType: GameNavigationType
    @ObservedObject var viewModel: GameViewModel = DependencyContainer.shared.resolve(GameViewModel.self)!
    
    @State private var timeLeft = 60
    @State private var timer: Timer? = nil
    let motionManager = CMMotionManager()
    
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
                    
                    if gameNavType == GameNavigationType.buttons || gameNavType == GameNavigationType.all {
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
                }
                .background(viewModel.backgroundColor)
                .alert(isPresented: $viewModel.showGameEndDialog) {
                    timer?.invalidate()
                    return Alert(title: Text("Game Over"), message: Text("You guessed \(viewModel.guessedWordsCount) words!"), dismissButton: .default(Text("OK"),action: {
                        router.navigateBack()
                    }))
                }.onAppear {
                    if gameNavType == GameNavigationType.tilt || gameNavType == GameNavigationType.all {
                        startDeviceMotionUpdates()
                    }
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
    
    func startDeviceMotionUpdates() {
        guard motionManager.isDeviceMotionAvailable else {
            print("Device motion is not available")
            return
        }
        
        motionManager.startDeviceMotionUpdates(to: .main) { motion, error in
            guard let motion = motion else { return }
            
            let zAcceleration = motion.userAcceleration.z
            
            if zAcceleration > 0.5 {
                print("Device tilted forward")
                viewModel.guessWord()
            } else if zAcceleration < -0.5 {
                print("Device tilted backward")
                viewModel.passWord()
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

#Preview {
    GameScreen(wordsCategory: WordsCategory.animals, gameNavType: GameNavigationType.all)
}
