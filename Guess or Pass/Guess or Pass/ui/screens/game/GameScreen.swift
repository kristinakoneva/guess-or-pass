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
    let tiltThreshold: Double = 60
    @State private var hasJustTilted: Bool = false
    
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
                                    if timeLeft > 0 {
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
                }
                .onAppear {
                    if gameNavType == .tilts || gameNavType == .all {
                        startDeviceMotionUpdates()
                    }
                }
                .onDisappear {
                    motionManager.stopDeviceMotionUpdates()
                }
                .gesture(
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
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .landscape))
            viewModel.fetchWords(for: self.wordsCategory)
        }.onDisappear {
            // TODO: Check if it is necessary to add this
//            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
//                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
        }
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        .background(viewModel.backgroundColor)
    }
    
    func startDeviceMotionUpdates() {
        guard motionManager.isDeviceMotionAvailable else {
            print("Device motion is not available")
            return
        }
        
        // TODO: Add landscape mode only logic
        /*
         Use roll instead of pitch.
         Roll values: -180 degrees (device on its face), -90 (neutral position), 0 (device on its back)
         */
        
        
        // Portrait mode logic
        func radiansToDegrees(_ radians: Double) -> Double {
            return radians * (180.0 / Double.pi)
        }
        
        motionManager.deviceMotionUpdateInterval = 1.0 / 50.0 // 50Hz
        
        motionManager.startDeviceMotionUpdates(to: .main) { motion, error in
            guard let motion = motion else { return }
            
            let quat = motion.attitude.quaternion
            let qPitch = CGFloat(radiansToDegrees(atan2(2 * (quat.x * quat.w + quat.y * quat.z), 1 - 2 * quat.x * quat.x - 2 * quat.z * quat.z)))
            
            // Extract the pitch angle from the motion's attitude
            let pitchDegrees = radiansToDegrees(motion.attitude.pitch)
            print("Current pitch: \(pitchDegrees)")
            
            if hasJustTilted && pitchDegrees < 70 {
                // Still hasn't returned to the neutral position from a tilt
                print("Recovering from a tilt")
                return
            } else {
                hasJustTilted = false
            }
            
            // Calculate the pitch difference from the neutral position
            let pitchDifference = abs(pitchDegrees - 90)
            print("Pitch difference: \(pitchDifference)")
            
            if pitchDifference >= self.tiltThreshold {
                // Tilt detected
                hasJustTilted = true
                if qPitch > 90 {
                    print("Device tilted forward")
                    // Perform actions for forward tilt
                    viewModel.guessWord()
                } else {
                    print("Device tilted backward")
                    // Perform actions for backward tilt
                    viewModel.passWord()
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

#Preview {
    GameScreen(wordsCategory: WordsCategory.animals, gameNavType: GameNavigationType.all)
}
