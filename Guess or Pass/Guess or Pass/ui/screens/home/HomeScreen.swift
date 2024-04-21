//
//  ContentView.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 20.4.24.
//

import SwiftUI

struct HomeScreen: View {
    @EnvironmentObject var router: Router
    @ObservedObject var viewModel: HomeViewModel = DependencyContainer.shared.resolve(HomeViewModel.self)!
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                // Handle settings action
                            }) {
                                Image(systemName: "gearshape.fill")
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 24))
                                    .padding()
                                    .padding(.top, 36)
                            }}
                        VStack{
                            if let userAvatar = viewModel.userAvatar {
                                Image(uiImage: userAvatar)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            }
                            
                            if let userName = viewModel.userName {
                                Text("Welcome \(userName)! 👋\nReady to play? 😁")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                    .padding(.top, 8)
                                    .padding(.bottom, 16)
                                    .padding(.horizontal, 24)
                            }
                        }}
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 0, style: .continuous)
                            .fill(Color.blue).clipShape(
                                .rect(
                                    topLeadingRadius: 0,
                                    bottomLeadingRadius: 24,
                                    bottomTrailingRadius: 24,
                                    topTrailingRadius: 0
                                )
                            )
                    )
                    
                    Text("Guess words for category:")
                        .font(.headline)
                        .padding(.horizontal, 24)
                        .padding(.top, 24)
                    
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
                }
            }
            .ignoresSafeArea(.all)
            .navigationBarHidden(true)
        }
        .alert(isPresented: $viewModel.showDialog) {
            if viewModel.showNoCategorySelectedDialog {
                Alert(title: Text("Select Category"), message: Text("Please select a category to play."), dismissButton: .default(Text("OK")){
                    viewModel.closeDialog()
                })
            }else{
                Alert(title: Text("Guess or Pass"), message: Text("You've chosen category \(viewModel.selectedCategory?.categoryName ?? ""). Try to guess as many words as you can in one minute. 💪\n\nGood luck! 🍀"), primaryButton: .default(Text("Start game")) {
                    viewModel.closeDialog()
                    router.navigate(to: .game(wordsCategory: viewModel.selectedCategory!))
                }, secondaryButton: .cancel(Text("Cancel")){
                    viewModel.closeDialog()
                })
            }
        }
        
        
        VStack {
            Button("Play") {
                viewModel.onPlayButtonClicked()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}

#Preview {
    HomeScreen()
}
