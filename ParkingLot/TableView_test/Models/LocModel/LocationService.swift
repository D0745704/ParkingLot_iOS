//
//  LocationService.swift
//  ParkingLotProject
//
//  Created by 仲輝 on 2022/3/28.
//

import UIKit
import CoreLocation

protocol LocationServiceDelegate {
    func tracingLocation(_ lastLocation: CLLocationCoordinate2D)
}

class LocationService: NSObject {
    
    static var shared: LocationService!
    
    static func getSharedInstance() -> LocationService {
        
        if shared == nil {
            shared = .init()
        }
        return shared
    }
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocationCoordinate2D?
    var delegate: LocationServiceDelegate?
    var isDenied: Bool = false
    
    override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        
        
        checkAuthorization()
        //檢查精確度(待修)
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
    
    }
    
    func startUpdatingLocation() {
        
        self.locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        
        self.locationManager?.stopUpdatingLocation()
    }
    
    func checkAuthorization() {
        
        switch locationManager?.authorizationStatus {
            
        case .notDetermined:
            locationManager?.requestAlwaysAuthorization()
            locationManager?.requestWhenInUseAuthorization()
            startUpdatingLocation()
        case .authorizedAlways, .authorizedWhenInUse:
            startUpdatingLocation()
        case .denied:
            self.isDenied = true
        default:
            break
        }
    }
    
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
//        if let location = locations.last {
//            print("test location")
//            currentLocation = location.coordinate
//        }
        currentLocation = manager.location?.coordinate
        print("Latitude: \(currentLocation!.latitude), Longitude: \(currentLocation!.longitude)")
        
        updateLocation(lastLocation: currentLocation!)
        stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error")
    }
    
    func updateLocation(lastLocation: CLLocationCoordinate2D){
        
        delegate?.tracingLocation(lastLocation)
    }
}

/*
 LocationService()  <-- Model

 1.詢問權限 k
    -> 精準度？判斷 (not yet
 2. 取得精準度是否有夠? ( not yet
 3. 正確的取得用戶位置 CLLocationManagerDelegate 收資料 k
 4. 錯誤處理 ( not yet

 */
