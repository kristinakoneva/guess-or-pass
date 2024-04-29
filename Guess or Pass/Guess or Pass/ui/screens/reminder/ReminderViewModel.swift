//
//  ReminderViewModel.swift
//  Guess or Pass
//
//  Created by Kristina Koneva on 28.4.24.
//

import Foundation
import MapKit

class ReminderViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let notificationManager: NotificationManager = DependencyContainer.shared.resolve(NotificationManager.self)!
    private let locationManager: CLLocationManager = DependencyContainer.shared.resolve(CLLocationManager.self)!
    private let geocoder: CLGeocoder = DependencyContainer.shared.resolve(CLGeocoder.self)!
    
    @Published var isLocationPickerPresented: Bool = false
    @Published var eventNameInput: String = "Game night 🥳"
    @Published var eventDateTime: Date = Date()
    @Published var locationName: String = "Skopje"
    @Published var selectedCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 41.9981, longitude: 21.4254) {
        didSet {
            geocoder.reverseGeocodeLocation(CLLocation(latitude: selectedCoordinates.latitude, longitude: selectedCoordinates.longitude)) { placemarks, error in
                if let error = error {
                    print("Reverse geocoding error: \(error.localizedDescription)")
                    return
                }
                
                guard let placemark = placemarks?.first else {
                    print("No placemark found")
                    return
                }
                
                self.locationName = placemark.name ?? placemark.locality ?? placemark.subLocality ?? placemark.subAdministrativeArea ?? placemark.administrativeArea ?? "Unknown"
            }
        }
    }
    @Published var isAlertDialogPresented: Bool = false
    @Published private(set) var alertDialog: ReminderAlertDialog? = nil
    
    
    override init() {
        super.init()
        self.eventDateTime = getTomorrowAt8PM()
        locationManager.delegate = self
    }
    
    func checkLocationPermissionsAndLocateUserIfPossible() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            locateUser()
            break
            
        case .restricted, .denied:
            locationName = "Skopje"
            break
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
            
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locateUser()
        }
    }
    
    private func locateUser() {
        guard let userLocation = locationManager.location else { return }
        
        geocoder.reverseGeocodeLocation(userLocation) { [weak self] placemarks, error in
            if let error = error {
                print("Reverse geocoding failed with error: \(error.localizedDescription)")
                return
            }
            guard let placemark = placemarks?.first else {
                print("No placemarks found.")
                return
            }
            if let name = placemark.name {
                DispatchQueue.main.async {
                    self?.locationName = name
                }
            } else {
                DispatchQueue.main.async {
                    self?.locationName = "Unknown"
                }
            }
        }
    }
    
    func openLocationPickerSheet() {
        self.isLocationPickerPresented = true
    }
    
    func closeLocationPickerSheet() {
        self.isLocationPickerPresented = false
    }
    
    private func getTomorrowAt8PM() -> Date {
        let calendar = Calendar.current
        var components = DateComponents()
        components.day = 1
        components.hour = 20
        components.minute = 0
        components.second = 0
        
        return calendar.date(byAdding: components, to: calendar.startOfDay(for: Date()))!
    }
    
    func setReminder() {
        if eventNameInput.isEmpty {
            eventNameInput = "Game night 🥳"
        }
        
        let currentPlusOneHour = Date().addingTimeInterval(3600)
        if eventDateTime < currentPlusOneHour {
            eventDateTime = getTomorrowAt8PM()
            return
        }
        
        let calendar = Calendar.current
        let notificationDate = calendar.date(byAdding: .hour, value: -1, to: eventDateTime) ?? eventDateTime
        
        notificationManager.requestAuthorization { granted in
            guard granted else {
                print("Notification permission not granted")
                self.alertDialog = .notificationPermissionDenied
                self.isAlertDialogPresented = true
                return
            }
            
            self.notificationManager.scheduleNotification(title: "Guees or Pass Reminder 🔔", body: self.getReminderNotificationBody(), date: notificationDate)
            self.alertDialog = .successfullySetReminder
            self.isAlertDialogPresented = true
        }
    }
    
    private func getReminderNotificationBody() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let formattedDate = dateFormatter.string(from: eventDateTime)
        return "Hey hey! 👋\n\nYour \"\(eventNameInput)\" event is starting in 1 hour.\n\n📅 Date & time: \(formattedDate)h\n\n📍 Location: \(locationName)"
    }
    
    func closeAlertDialog() {
        isAlertDialogPresented = false
        alertDialog = nil
    }
}
