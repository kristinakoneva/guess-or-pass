//
//  WelcomeScreen.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 20.4.24.
//

import SwiftUI

struct WelcomeScreen: View {
    @EnvironmentObject var router: Router
    @ObservedObject var viewModel: WelcomeViewModel = DependencyContainer.shared.resolve(WelcomeViewModel.self)!
    
    @State private var selectedImage: UIImage?
    
    var body: some View {
       ScrollView {
            VStack(alignment: .center) {
                Spacer()
                Text("Hi! 😄\nWhat's your name?")
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .padding()
                
                TextField("Enter your name", text: $viewModel.nameInput)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                
                
                if let selectedImage = selectedImage {
                    Text("👤 Your avatar will be:")
                        .padding(.top, 10)
                    
                    Image(uiImage: selectedImage)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                }
                
                Text("Choose your avatar:").padding(.top, 10)
                
                HStack {
                    Button(action: {
                        viewModel.openPhotoGallery()
                    }) {
                        Text("Choose from gallery 🖼️")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.openCamera()
                    }) {
                        Text("Take photo now 📸")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .padding()
                }
                .padding(.bottom, 32)
                
                Button("Let's play 🥳") {
                    if viewModel.nameInput.isEmpty || selectedImage == nil {
                        viewModel.isAlertPresented = true
                    } else {
                        saveImageToLocalStorage(image: selectedImage!)
                        viewModel.saveUserName()
                        router.navigate(to: .home)
                    }
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                .fontWeight(.bold)
                Spacer()
            }
            .padding()
            .onAppear {
                if !viewModel.isNewUser {
                    router.navigate(to: .home)
                }
            }
            .sheet(isPresented: $viewModel.shouldOpenImagePicker) {
                ImagePicker(selectedImage: self.$selectedImage, sourceType: viewModel.imagePickerSourceType)
            }
            .alert(isPresented: $viewModel.isAlertPresented) {
                switch viewModel.alertDailog {
                case .cameraPermissionDenied:
                    Alert(title: Text("Camera permission denied"), message: Text("If you want to take a photo with your camera and set it as your avatar, you will have to grant the camera permission in the settings."), dismissButton: .default(Text("OK"), action: { viewModel.closeAlertDialog() }))
                default:
                    Alert(title: Text("Please provide input"), message: Text("Name and/or avatar selection are/is missing."), dismissButton: .default(Text("OK"), action: { viewModel.closeAlertDialog() }))
                }
            }
        }
    }
    
    func saveImageToLocalStorage(image: UIImage) {
        if let imageData = image.pngData() {
            viewModel.saveUserAvatar(imageData: imageData)
        }
    }
}

#Preview {
    WelcomeScreen()
}
