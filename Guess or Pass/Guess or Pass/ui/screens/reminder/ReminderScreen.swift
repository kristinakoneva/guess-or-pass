//
//  ReminderScreen.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 28.4.24.
//

import SwiftUI


struct ReminderScreen: View {
    @ObservedObject var viewModel: ReminderViewModel = DependencyContainer.shared.resolve(ReminderViewModel.self)!
    
    @State private var eventName = ""
    @State private var selectedDate = Date()
    
    var body: some View {
        ScrollView {
            VStack {
                TextField("Event Name", text: $eventName)
                    .padding()
                
                // Date and Time Picker
                DatePicker("Select Date and Time", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                    .padding()
                
                // Location Picker Button
                Button("Choose Location") {
                    // Present location picker here
                    // This could open a modal sheet containing a map or use a map view
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Spacer()
            }
            .padding()
            .navigationBarTitle("Set Reminder")
        }
    }
}
