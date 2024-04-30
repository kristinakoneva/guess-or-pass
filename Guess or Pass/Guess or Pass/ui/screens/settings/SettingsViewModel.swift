//
//  SettingsViewModel.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 21.4.24.
//

import Foundation
import SwiftUI
import AVFoundation

class SettingsViewModel: ObservableObject {
    private let userRepository: UserRepository
    
    @Published var name: String = ""
    @Published private(set) var avatar: UIImage? = nil
    @Published private(set) var bestScore: Int? = nil
    
    @Published var navigateToSetReminder = false
    
    @Published private(set) var settingsActionSheet: SettingsActionSheet? = nil
    @Published private(set) var settingsSheet: SettingsSheet? = nil
    @Published var isActionSheetPresented = false
    @Published var isSheetPresented = false
    @Published var isCameraPermissionDeniedAlertPresented: Bool = false
    
    let settingsItems: [SettingsItem] = [
        .changeName,
        .changeAvatar,
        .readInstructions,
        .changeGameNavigation,
        .setReminder
    ]
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
        self.name = userRepository.getUserName() ?? ""
        self.avatar = UIImage(data: userRepository.getUserAvatar()!)
        self.bestScore = userRepository.getBestScore()
    }
    
    func onSettingsActionClicked(action: SettingsAction) {
        switch action {
        case .changeName:
            self.settingsSheet = .nameChange
            self.isSheetPresented = true
            break
        case .changeAvatar:
            self.settingsActionSheet = .avatarChange
            self.isActionSheetPresented = true
            break
        case .changeGameNavigation:
            self.settingsActionSheet = .gameNavType
            self.isActionSheetPresented = true
            break
        case .readInstructions:
            self.settingsSheet = .instructions
            self.isSheetPresented = true
            break
        case .setReminder:
            self.navigateToSetReminder = true
        }
    }
    
    func saveGameNavTypeChoice(navType: GameNavigationType) {
        closeActionSheet()
        userRepository.saveGameNavigationType(navType)
    }
    
    func saveNewName(newName: String) {
        userRepository.saveUserName(newName)
        self.name = newName
        isSheetPresented = false
        settingsSheet = nil
    }
    
    func saveNewAvatar(newAvatar: UIImage?){
        if newAvatar != nil {
            userRepository.saveUserAvatar(newAvatar!.pngData()!)
            avatar = newAvatar
        }
        closeActionSheet()
    }
    
    func openImagePicker(sourceType: UIImagePickerController.SourceType) {
        if sourceType == .photoLibrary {
            settingsSheet = .galleryImagePicker
            isSheetPresented = true
        } else {
            let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
            switch cameraAuthorizationStatus {
            case .authorized:
                settingsSheet = .cameraImagePicker
                isSheetPresented = true
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    DispatchQueue.main.async {
                        if granted {
                            self.settingsSheet = .cameraImagePicker
                            self.isSheetPresented = true
                        } else {
                            self.isCameraPermissionDeniedAlertPresented = true
                        }
                    }
                }
            case .denied, .restricted:
                self.isCameraPermissionDeniedAlertPresented = true
            @unknown default:
                break
            }
        }
        
    }
    
    func closeSheet() {
        self.isSheetPresented = false
        self.settingsSheet = nil
    }
    
    func closeActionSheet() {
        self.isActionSheetPresented = false
        self.settingsActionSheet = nil
    }
    
    func clearNavigationEvent() {
        self.navigateToSetReminder = false
    }
    
    func closeAlertDialog() {
        self.isCameraPermissionDeniedAlertPresented = false
    }
}
