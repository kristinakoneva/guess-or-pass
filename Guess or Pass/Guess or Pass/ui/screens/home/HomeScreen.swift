//
//  ContentView.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 20.4.24.
//

import SwiftUI

struct HomeScreen: View {
    
    @EnvironmentObject var router: Router
    private let repoo: WordsRepository = DependencyContainer.shared.resolve(WordsRepository.self)!
    
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding().onAppear{
            testFetchWords()
        }
    }
    func testFetchWords() {
        let repo = WordsRepositoryImpl(apiSource: DatamuseApiSourceImpl())
        
        repo.fetchWords(for: WordsCategory.food) { result in
            switch result {
            case .success(let words):
                print("Fetched words: \(words)")
            case .failure(let error):
                print("Error fetching words: \(error)")
            }
        }
    }
}

#Preview {
    HomeScreen()
}
