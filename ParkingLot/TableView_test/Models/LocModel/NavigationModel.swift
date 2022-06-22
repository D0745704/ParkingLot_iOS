//
//  NavigationModel.swift
//  ParkingLotProject
//
//  Created by 仲輝 on 2022/3/17.
//

import Foundation
import MapKit

class NavigationModel {
    
    let locTool = LocationMathTool()
    
    func getCoordinate(from coordA: CLLocationCoordinate2D, to coordB: CLLocationCoordinate2D,
                      on mapView: MKMapView, completion: @escaping (MKDirections.Response) -> Void) {
        
        //目的地座標
        let sourcePlacemark = MKPlacemark(coordinate: coordA)
        let destPlacemark = MKPlacemark(coordinate: coordB)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: sourcePlacemark)
        request.destination = MKMapItem(placemark: destPlacemark)
        
        request.requestsAlternateRoutes = false
        request.transportType = .automobile
       
        //替目的地上標示
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.coordinate = coordB
        destinationAnnotation.title = "Destination!"
      
        //起始點標記
        let startAnnotation = MKPointAnnotation()
        startAnnotation.coordinate = coordA
        startAnnotation.title = "Start!"
        //加入標記
        mapView.addAnnotation(destinationAnnotation)
        mapView.addAnnotation(startAnnotation)
        //設定初始畫面範圍
        let mapZoom: [CLLocationCoordinate2D] = [request.source!.placemark.coordinate, request.destination!.placemark.coordinate]
        mapView.setRegion(MKCoordinateRegion.init(coordinates: mapZoom), animated: true)
        
        let directions = MKDirections(request: request)

        directions.calculate { response, error in
            guard let resp = response else { return }
            completion(resp)
        }
    }
}
