//
//  InjectionContainer.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 20.4.24.
//

import Swinject
import CoreMotion

class DependencyContainer {
    static let shared = DependencyContainer()
    
    private let container = Container()
    
    private init() {
        registerDependencies()
    }
    
    private func registerDependencies() {
        // Sources
        container.register(LocalStorage.self) { _ in
            return LocalStorageImpl()
        }
        container.register(DatamuseApiSource.self) { _ in
            return DatamuseApiSourceImpl()
        }
        
        // Repositories
        container.register(UserRepository.self) { r in
            return UserRepositoryImpl(localStorage: r.resolve(LocalStorage.self)!)
        }
        container.register(WordsRepository.self) { r in
            return WordsRepositoryImpl(apiSource: r.resolve(DatamuseApiSource.self)!)
        }
        
        // ViewModels
        container.register(WelcomeViewModel.self) { r in
            return WelcomeViewModel(userRepository: r.resolve(UserRepository.self)!)
        }
        container.register(HomeViewModel.self) { r in
            return HomeViewModel(userRepository: r.resolve(UserRepository.self)!)
        }
        container.register(GameViewModel.self) { r in
            let wordsRepository = r.resolve(WordsRepository.self)!
            let userRepository = r.resolve(UserRepository.self)!
            return GameViewModel(wordsRepository: wordsRepository, userRepository: userRepository)
        }
        container.register(SettingsViewModel.self) { r in
            return SettingsViewModel(userRepository: r.resolve(UserRepository.self)!)
        }
        container.register(ReminderViewModel.self) { _ in
            return ReminderViewModel()
        }
        
        // Motion Manager
        container.register(CMMotionManager.self) { _ in
            return CMMotionManager()
        }.inObjectScope(.container)
        
        // Notification Manager
        container.register(NotificationManager.self) { _ in
            return NotificationManager()
        }.inObjectScope(.container)
    }
    
    func resolve<T>(_ serviceType: T.Type) -> T? {
        return container.resolve(serviceType)
    }
}
