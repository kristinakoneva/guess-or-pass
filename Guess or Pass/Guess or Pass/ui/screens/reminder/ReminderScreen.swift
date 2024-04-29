//
//  ReminderScreen.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 28.4.24.
//

import SwiftUI
import LocationPicker
import MapKit


struct ReminderScreen: View {
    @ObservedObject var viewModel: ReminderViewModel = DependencyContainer.shared.resolve(ReminderViewModel.self)!
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Enter the event name, date, time and location and we will send you a notification one hour before the event to remind you about it. 🔔")
                
                Text("Event name:").font(.title2).padding(.top, 12).fontWeight(.bold)
                TextField("Event name", text: $viewModel.eventNameInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Text("Date and time:").font(.title2).padding(.top, 12).fontWeight(.bold)
                DatePicker("Select Date and Time", selection: $viewModel.eventDateTime, in: Date().addingTimeInterval(3660)..., displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .labelsHidden()
                
                
                Text("Location:").font(.title2).padding(.top, 12).fontWeight(.bold)
                Text("\(viewModel.locationName)").font(.title2)
                Button("Change location") {
                    viewModel.openLocationPickerSheet()
                }
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                HStack {
                    Spacer()
                    Button("Set reminder 🔔") {
                        // TODO: Implement set reminder logic
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .font(.system(size: 18, weight: .bold))
                    Spacer()
                }.padding(.top, 24)
            }
            .sheet(isPresented: $viewModel.isLocationPickerPresented, onDismiss: {
                viewModel.closeLocationPickerSheet()
            }) {
                LocationPicker(instructions: "Tap to select location", coordinates: $viewModel.selectedCoordinates, zoomLevel: 0.5, dismissOnSelection: true)
            }
            .onAppear {
                viewModel.checkLocationPermissionsAndLocateUserIfPossible()
            }
            .padding(.horizontal, 16)
            .padding()
            .navigationBarTitle("Set Reminder")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


#Preview {
    ReminderScreen()
}
