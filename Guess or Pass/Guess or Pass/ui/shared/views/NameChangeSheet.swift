//
//  NameChangeSheet.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 23.4.24.
//

import SwiftUI

struct NameChangeSheet: View {
    @Binding var newName: String
    var onSuccess: (String) -> Void
    var onDismiss: () -> Void
    
    @EnvironmentObject var orientationInfo: OrientationInfo
    
    var body: some View {
        VStack {
            if orientationInfo.orientation == .landscape {
                HStack {
                    Button("Close") {
                        onDismiss()
                    }
                    Spacer()
                }.padding(.top, 24)
            }
            Spacer()
            
            Text("Enter your new name ✍️")
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .padding(.horizontal, 32)
                .padding()
            
            TextField("Name", text: $newName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.top, 32)
                .padding(.horizontal, 32)
                .padding(.bottom, 24)
            
            Button("Save") {
                if !newName.isEmpty {
                    onSuccess(newName)
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            Spacer()
        }
    }
}
