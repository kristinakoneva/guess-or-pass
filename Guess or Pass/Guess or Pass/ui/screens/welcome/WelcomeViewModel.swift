//
//  WelcomeViewModel.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 20.4.24.
//

import Foundation
import SwiftUI
import AVFoundation

class WelcomeViewModel: ObservableObject {
    private let userRepository: UserRepository
    
    @Published var nameInput: String = ""
    @Published private(set) var isNewUser: Bool = true
    @Published var shouldOpenImagePicker = false
    @Published private(set) var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    @Published var isAlertPresented = false
    @Published var alertDailog: WelcomeAlertDialog? = nil
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
        let name = userRepository.getUserName()
        let avatar = userRepository.getUserAvatar()
        if name != nil || avatar != nil {
            isNewUser = false
        }
    }
    
    func saveUserName() {
        userRepository.saveUserName(nameInput)
    }
    
    func saveUserAvatar(imageData: Data){
        userRepository.saveUserAvatar(imageData)
    }
    
    func openCamera() {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthorizationStatus {
        case .authorized:
            self.imagePickerSourceType = .camera
            self.shouldOpenImagePicker = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.imagePickerSourceType = .camera
                        self.shouldOpenImagePicker = true
                    } else {
                        self.alertDailog = .cameraPermissionDenied
                        self.isAlertPresented = true
                    }
                }
            }
        case .denied, .restricted:
            self.alertDailog = .cameraPermissionDenied
            self.isAlertPresented = true
        @unknown default:
            break
        }
    }
    
    func openPhotoGallery() {
        imagePickerSourceType = .photoLibrary
        shouldOpenImagePicker = true
    }
    
    func closeImagePicker() {
        shouldOpenImagePicker = false
    }
    
    func closeAlertDialog() {
        isAlertPresented = false
        alertDailog = nil
    }
}
