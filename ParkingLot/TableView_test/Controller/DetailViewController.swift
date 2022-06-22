//
//  DetailViewController.swift
//  ParkingLotTestVer
//
//  Created by 仲輝 on 2022/3/7.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    //經緯轉換
    let locTool = LocationMathTool()
    let navModel = NavigationModel()
    let locService = LocationService()
    let apiModel = APIModel()
    let dbModel = DBModel()
    
    var parkingDesc: Parking!
    var userLoc: CLLocationCoordinate2D!
    private var animator: UIViewPropertyAnimator!
    
    //MARK: - Labels
    //停車場資訊
    @IBOutlet weak var nameDetailLabel: UILabel!
    @IBOutlet weak var areaDetailLabel: UILabel!
    @IBOutlet weak var timeDetailLabel: UILabel!
    @IBOutlet weak var addrDetailLabel: UILabel!
    //停車場地圖
    @IBOutlet weak var parkingMap: MKMapView!
    //顯示時間距離
    @IBOutlet weak var travelTime: UILabel!
    @IBOutlet weak var distance: UILabel!
    //Floating Panel
    @IBOutlet weak var floatingView: UIView! 
    //Weather data
    @IBOutlet weak var weatherView: UIView!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    
    //MARK: - 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getDirection()
        
        setLabelsName()
        setWeatherView()
        setFloatView()
        getWeatherData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    //MARK: - IBAction
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func routeButton(_ sender: Any) {
        //導航
        getNavigationRoute()
    }
    
}

//MARK: - Methods
extension DetailViewController {
    
    func setLabelsName() {
        //labels
        nameDetailLabel.text = self.parkingDesc.loc
        areaDetailLabel.text = self.parkingDesc.area
        timeDetailLabel.text = self.parkingDesc.servTime
        addrDetailLabel.text = self.parkingDesc.addr
    }
    
    func setWeatherView() {
        
        weatherView.layer.cornerRadius = 6
        weatherView.layer.borderColor = UIColor.systemGray3.cgColor
        weatherView.layer.borderWidth = 0.5
        weatherView.layer.masksToBounds = true
    }
    
    func getWeatherData() {
        apiModel.getWeatherDataFromURL(coord: userLoc) { objects in
            
            objects.forEach { content in
                //資料顯示
                let icon: String = content.icon!
                let urlString = "https://openweathermap.org/img/wn/\(icon)@2x.png"
                if let url = URL(string: urlString) {
                    URLSession.shared.dataTask(with: url) { (data, response, error) in
                        if let data = data,
                           let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self.weatherIcon.image = image
                            }
                        }
                    }.resume()
                }
                //self.weatherIcon.image = image
                self.temperature.text = String(Int(content.temp!)) + "°"
                //self.dbModel.insertObjects(weatherData: content)
            }
        }
    }
    
    func getDirection() {

        let loc = locTool.convertTWDToGWS(x: parkingDesc.latitude, y: parkingDesc.longitude)
        let userLocation = userLoc
        
        navModel.getCoordinate(from: userLocation!,
                              to: CLLocationCoordinate2D(latitude: loc.lat, longitude: loc.lng),
                              on: parkingMap) { response in
            var second: Int
            let route = response.routes.first
            second = Int(route!.expectedTravelTime)
            
            let (minute, _) = second.quotientAndRemainder(dividingBy: 60)
            let (hour, min) = minute.quotientAndRemainder(dividingBy: 60)
            
            if hour > 0 {
                self.travelTime.text = "\(hour) 小時 \(min) 分鐘"
            } else {
                self.travelTime.text = "\(min) 分鐘"
            }
            self.distance.text = String(format:"%.1f", route!.distance / 1000) + "公里"
            if let line = route?.polyline {
                self.parkingMap.addOverlay(line, level: .aboveRoads)
            }
        }
    }
    
    func setFloatView() {
        
        floatingView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        floatingView.layer.cornerRadius = 20
        floatingView.layer.masksToBounds = true // == Uiview 要客製化
        floatingView.transform = CGAffineTransform(translationX: 0, y: floatingView.bounds.height)
        
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.6,
            delay: 0,
            options: [.curveEaseOut]) {
                //背景變很暗 蠻好看的
                //self.view.backgroundColor = UIColor(white: 0, alpha: 0.8)
                self.floatingView.transform = .identity
            }
    }
}

//MARK: - Apple Map
extension DetailViewController: CLLocationManagerDelegate {
    //apple map 頁面
    func getNavigationRoute() {
        
        let loc = locTool.convertTWDToGWS(x: parkingDesc.latitude, y: parkingDesc.longitude)
        let request = MKDirections.Request()
        let userLocation = userLoc
        let destination = CLLocationCoordinate2D(latitude: loc.lat, longitude: loc.lng)
        
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation!))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        
        let routes = [request.source!, request.destination!]
        MKMapItem.openMaps(with: routes, launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
//        //testLat = locValue.latitude
//        //testLng = locValue.longitude
//        currentLocation = locValue
//        print("test: user locations = \(locValue.latitude) \(locValue.longitude)")
//    }
}

//MARK: - MapDelegate
extension DetailViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")
        switch annotation.title!! {
            case "Start!":
                annotationView.markerTintColor = UIColor(red: (146.0/255), green: (187.0/255), blue: (217.0/255), alpha: 1.0)
            case "Destination!":
                annotationView.markerTintColor = UIColor(red: (176.0/255), green: (100.0/255), blue: (212.0/255), alpha: 1.0)
            default:
                annotationView.markerTintColor = UIColor.blue
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = UIColor.blue
        polylineRenderer.fillColor = UIColor.red
        polylineRenderer.lineWidth = 4
        return polylineRenderer
    }
}
