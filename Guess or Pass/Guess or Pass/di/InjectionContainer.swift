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
            let userRepository = r.resolve(UserRepository.self)!
            let wordsRepository = r.resolve(WordsRepository.self)!
            return HomeViewModel(userRepository: userRepository, wordsRepository: wordsRepository)
        }
    }
    
    func resolve<T>(_ serviceType: T.Type) -> T? {
        return container.resolve(serviceType)
    }
}
