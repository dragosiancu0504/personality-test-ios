//
//  LocationProvider.swift
//  PersonalityTest
//
//  Created by Razvan Balint on 05/02/2021.
//

import Foundation
import CoreLocation
import Combine
import UIKit

class LocationProvider: NSObject, ObservableObject {
    
    
    @Published private(set) var location: CLLocation?
    let userDefault = UserDefaults.standard
    
    private let locationManager = CLLocationManager()
    private var authorizationStatus: CLAuthorizationStatus? = .notDetermined
    
    override init() {
        super.init()
        
        locationManager.delegate = self
    }
    
    func requestAuthorization() -> Void {
        if authorizationStatus == .denied {
            presentLocationSettingsAlert()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func start() -> Void {
        locationManager.startMonitoringSignificantLocationChanges()
        if let lat = locationManager.location?.coordinate.latitude,
           let long =  locationManager.location?.coordinate.longitude {
            location = CLLocation(latitude: lat, longitude: long)
        }
    }
    
    func stop() -> Void {
        locationManager.stopMonitoringSignificantLocationChanges()
        if let lat = locationManager.location?.coordinate.latitude,
           let long =  locationManager.location?.coordinate.longitude {
            location = CLLocation(latitude: lat, longitude: long)
        }
    }
}

extension LocationProvider: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        
        authorizationStatus = status
        switch authorizationStatus {
        case .notDetermined, .restricted, .denied:
            print("Location denied")
            self.requestAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            print("Location allowed")
            
            locationManager.startMonitoringSignificantLocationChanges()
            if let lat = locationManager.location?.coordinate.latitude,
               let long =  locationManager.location?.coordinate.longitude {
                location = CLLocation(latitude: lat, longitude: long)
            }
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
    }
}

private extension LocationProvider {
    func presentLocationSettingsAlert() -> Void {
        let alertController = UIAlertController(title: "Locatie dezactivata",
                                                message: "Aplicatia nu are acces la locatie. Activati locatia in setari",
                                                preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Setari", style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settingsUrl)
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Anuleaza", style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}



