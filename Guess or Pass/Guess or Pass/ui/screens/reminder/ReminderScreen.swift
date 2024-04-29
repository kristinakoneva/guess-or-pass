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
    @EnvironmentObject var router: Router
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
                        viewModel.setReminder()
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
                LocationPicker(instructions: "Tap to select location 📍", coordinates: $viewModel.selectedCoordinates, zoomLevel: 0.5, dismissOnSelection: true)
            }
            .alert(isPresented: $viewModel.isAlertDialogPresented) {
                switch viewModel.alertDialog {
                case .successfullySetReminder:
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
                    let formattedDate = dateFormatter.string(from: viewModel.eventDateTime)
                    return Alert(title: Text("Reminder set ✅"), message: Text("We will send you a notification 1 hour before \"\(viewModel.eventNameInput)\" on \(formattedDate)h."), dismissButton: .default(Text("OK"),action: {
                        router.navigateBack()
                    }))
                default:
                    return Alert(title: Text("Notifications are disabled 🔕"), message: Text("Please enable notifications in the app settings if you want to recieve a reminder for your \"\(viewModel.eventNameInput)\" event."), dismissButton: .default(Text("OK"),action: {
                        viewModel.closeAlertDialog()
                    }))
                }
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
