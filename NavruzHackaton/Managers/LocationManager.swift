//
//  LocationManager.swift
//  NavruzHackaton
//
//  Created by Muhammadjon Madaminov on 19/03/25.
//


import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var location: CLLocation?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        // Request permission to access location while the app is in use.
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Update the published location with the most recent value.
        if let loc = locations.last {
            DispatchQueue.main.async {
                self.location = loc
            }
        }
    }
}
