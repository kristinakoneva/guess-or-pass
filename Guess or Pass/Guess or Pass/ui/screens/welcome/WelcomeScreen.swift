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
    @State private var isImagePickerPresented = false
    @State private var selectedAvatarIndex: Int = 0
    
    var body: some View {
        VStack {
            Text("Hi! What's your name?")
                .font(.largeTitle)
                .padding()
            
            TextField("Enter your name", text: $viewModel.nameInput)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Text("Your avatar will be:")
                .padding(.top, 10)
            
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .padding()
                    .background(Color.blue.opacity(0.3))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue, lineWidth: 2)
                    )
            } else {
                AvatarImage(systemName: "person.fill", isSelected: true)
                    .padding()
            }
            
            Text("Select a different avatar:")
            
            HStack {
                ForEach(0..<3) { index in
                    AvatarImage(systemName: "person.fill", isSelected: index == selectedAvatarIndex)
                        .padding()
                        .onTapGesture {
                            selectedAvatarIndex = index
                            selectedImage = nil
                        }
                }
            }
            
            HStack {
                Spacer()
                Button(action: {
                    self.isImagePickerPresented.toggle()
                    selectedAvatarIndex = -1
                }) {
                    Text("Choose Custom Avatar")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                Spacer()
            }
            
            Button("Let's play") {
                if let image = selectedImage {
                    saveImageToLocalStorage(image: image)
                }
                viewModel.saveName()
                router.navigate(to: .home)
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .onAppear {
            selectedAvatarIndex = 0
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImage: self.$selectedImage, isPresented: self.$isImagePickerPresented)
        }
    }
    
    func saveImageToLocalStorage(image: UIImage) {
        if let imageData = image.pngData() {
            viewModel.saveUserAvatar(imageData: imageData)
            self.selectedImage = image
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
