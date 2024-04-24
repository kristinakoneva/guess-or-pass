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
    let motionManager = DependencyContainer.shared.resolve(CMMotionManager.self)!
    @State private var initialPitch: Double? = nil
    @State private var tiltThreshold: Double = 90
    
    var body: some View {
        Group {
            if viewModel.isCountdownFinished {
                VStack {
                    HStack {
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
                                        motionManager.stopDeviceMotionUpdates()
                                    }
                                }
                            }
                        Spacer()
                        Button("End Game", action: {
                            viewModel.endGame()
                            motionManager.stopDeviceMotionUpdates()
                        })
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }.padding(.horizontal)
                    
                    Spacer()
                    
                    Text(viewModel.currentWord)
                        .font(.largeTitle)
                        .foregroundColor(Color.white)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding()
                    
                    Spacer()
                    
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
                .padding(.vertical, 54)
                .padding(.horizontal, 16)
                .alert(isPresented: $viewModel.showGameEndDialog) {
                    timer?.invalidate()
                    return Alert(title: Text("Game Over"), message: Text("You guessed \(viewModel.guessedWordsCount) words!"), dismissButton: .default(Text("OK"),action: {
                        router.navigateBack()
                    }))
                }.onAppear {
                    if gameNavType == .tilts || gameNavType == .all {
                        startDeviceMotionUpdates()
                    }
                }.onDisappear {
                    motionManager.stopDeviceMotionUpdates()
                }.gesture(
                    DragGesture()
                        .onEnded { gesture in
                            if gameNavType == .swipes || gameNavType == .all {
                                if gesture.translation.width < 0 {
                                    viewModel.passWord()
                                }
                                
                                if gesture.translation.width > 0 {
                                    viewModel.guessWord()
                                }
                            }
                        }
                )
            } else {
                CountdownView() {
                    viewModel.startGame()
                }
            }
        }.onAppear {
            viewModel.fetchWords(for: self.wordsCategory)
        }
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        .background(viewModel.backgroundColor)
    }
    
    func startDeviceMotionUpdates() {
        guard motionManager.isDeviceMotionAvailable else {
            print("Device motion is not available")
            return
        }
        
        // Update interval
        motionManager.deviceMotionUpdateInterval = 1.0 / 50.0 // 50Hz
        
        motionManager.startDeviceMotionUpdates(to: .main) { motion, error in
            guard let motion = motion else { return }
            
            if viewModel.shouldObserveMotionUpdates {
                // Debugging
                let userAcceleration = motion.userAcceleration
                let gravity = motion.gravity
                let rotationRate = motion.rotationRate
                let attitude = motion.attitude
                
                print("User Acceleration: \(userAcceleration.x), \(userAcceleration.y), \(userAcceleration.z)")
                print("Gravity: \(gravity.x), \(gravity.y), \(gravity.z)")
                print("Rotation Rate: \(rotationRate.x), \(rotationRate.y), \(rotationRate.z)")
                
                let roll = 180 / .pi * attitude.roll
                let pitch = 180 / .pi * attitude.pitch
                let yaw = 180 / .pi * attitude.yaw
                print("Roll: \(roll)°, Pitch: \(pitch)°, Yaw: \(yaw)°")
                
                
                
                
                // Extract the pitch angle from the motion's attitude
                let pitchDegrees = 180 / .pi * motion.attitude.pitch
                
                if self.initialPitch == nil {
                    // Set initial pitch value
                    self.initialPitch = pitchDegrees
                } else {
                    // Calculate the pitch difference from the initial pitch
                    let pitchDifference = abs(pitchDegrees - (self.initialPitch ?? 0))
                    
                    if pitchDifference >= self.tiltThreshold {
                        // Tilt detected
                        if motion.gravity.y < 0 {
                            print("Device tilted forward")
                            // Perform actions for forward tilt
                            viewModel.guessWord()
                        } else {
                            print("Device tilted backward")
                            // Perform actions for backward tilt
                            viewModel.passWord()
                        }
                        
                        // Reset initial pitch value
                        self.initialPitch = nil
                    }
                }
            }
        }
    }
}

struct CountdownView: View {
    var onFinish
    : () -> Void
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
