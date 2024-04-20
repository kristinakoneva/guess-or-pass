//
//  ContentView.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 20.4.24.
//

import SwiftUI

struct HomeScreen: View {
    @ObservedObject var viewModel: HomeViewModel = DependencyContainer.shared.resolve(HomeViewModel.self)!

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            // Handle settings action
                        }) {
                            Image(systemName: "gearshape.fill")
                                .padding()
                        }
                    }

                    if let userAvatar = viewModel.userAvatar {
                        Image(uiImage: userAvatar)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .padding()
                    }

                    if let userName = viewModel.userName {
                        Text("Welcome \(userName)! Ready to play?")
                            .font(.title)
                            .padding()
                    }

                    Text("Guess words for category:")
                        .font(.headline)
                        .padding()

                    LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 10) {
                        ForEach(viewModel.categories, id: \.self) { category in
                            WordsCategoryView(category: category, isSelected: Binding(
                                get: { category == viewModel.selectedCategory },
                                set: { _ in }
                            ))
                            .onTapGesture {
                                viewModel.selectCategory(category)
                            }
                        }
                    }
                    .padding()

                    Spacer()

                    Button(action: {
                        viewModel.onPlayButtonClicked()
                    }) {
                        Text("Play")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            }
            .navigationBarHidden(true)
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Select Category"), message: Text("Please select a category to play."), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    HomeScreen()
}
