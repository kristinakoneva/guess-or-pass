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
    @State private var shouldOpenImagePicker = false
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var isAlertPresented = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    
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
                        Spacer()
                        Button(action: {
                            self.imagePickerSourceType = .photoLibrary
                            self.shouldOpenImagePicker = true
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
                            self.imagePickerSourceType = .camera
                            self.shouldOpenImagePicker = true
                        }) {
                            Text("Take photo now 📸")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        
                    }
                    .padding(.bottom, 32)
                    
                    Button("Let's play") {
                        if viewModel.nameInput.isEmpty || selectedImage == nil {
                            isAlertPresented = true
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
                }
                .padding()
                .onAppear {
                    if !viewModel.isNewUser {
                        router.navigate(to: .home)
                    }
                }
                .sheet(isPresented: $shouldOpenImagePicker) {
                    ImagePicker(selectedImage: self.$selectedImage, sourceType: imagePickerSourceType)
                }.onAppear {
                    shouldOpenImagePicker = false
                }
                .alert(isPresented: $isAlertPresented) {
                    Alert(title: Text("Please provide input"), message: Text("Name and/or avatar selection are/is missing."), dismissButton: .default(Text("OK")))
                }
            }}}
    
    func saveImageToLocalStorage(image: UIImage) {
        if let imageData = image.pngData() {
            viewModel.saveUserAvatar(imageData: imageData)
        }
    }
}

struct AvatarImage: View {
    var systemName: String
    var isSelected: Bool
    
    var body: some View {
        Image(systemName: systemName)
            .resizable()
            .frame(width: 50, height: 50)
            .padding()
            .background(isSelected ? Color.blue.opacity(0.3) : Color.clear)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
    }
}

#Preview {
    WelcomeScreen()
}
