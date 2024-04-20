//
//  InjectionContainer.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 20.4.24.
//

import Swinject

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
        
        // Repositories
        container.register(UserRepository.self) { r in
            return UserRepositoryImpl(localStorage: r.resolve(LocalStorage.self)!)
        }
        
        // ViewModels
        container.register(WelcomeViewModel.self) { r in
            return WelcomeViewModel(userRepository: r.resolve(UserRepository.self)!)
        }
    }
    
    func resolve<T>(_ serviceType: T.Type) -> T? {
        return container.resolve(serviceType)
    }
}
