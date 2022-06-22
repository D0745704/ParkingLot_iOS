//
//  APIModel.swift
//  ParkingLotTestVer
//
//  Created by 仲輝 on 2022/3/8.
//

import UIKit
import CoreLocation

class APIModel: NSObject {

    private let parkingAddress = "https://data.ntpc.gov.tw/api/datasets/B1464EF0-9C7C-4A6F-ABF7-6BDF32847E68/json?page=0&size=100"
    
    // Call API, 取得到 ParkJsonObject
    func getParkingDataFromURL(handle: @escaping (_ objects: [DataContents]) -> Void) {

        getDataFromURL(from: parkingAddress) { data in
            do {
                var objects: [DataContents] = [DataContents]()
                let decoder = JSONDecoder()
                if let parkingData = try? decoder.decode([ParkingData].self, from: data) {
                    
                    for parking in parkingData {
                        
                        let latitude = Double(parking.TW97X) ?? 0
                        let longitude = Double(parking.TW97Y) ?? 0
                        let type = Int16(parking.TYPE) ?? 0
                        let car = Int16(parking.TOTALCAR) ?? 0
                        let motor = Int16(parking.TOTALMOTOR) ?? 0
                        let bike = Int16(parking.TOTALBIKE) ?? 0
                        
                        let content = DataContents(id: parking.ID, area: parking.AREA, location: parking.NAME, type: type, summ: parking.SUMMARY, addr: parking.ADDRESS, tel: parking.TEL, pay: parking.PAYEX, time: parking.SERVICETIME, lat: latitude, lng: longitude, totalCar: car, totalMotor: motor, totalBike: bike)
                        if content.id != nil {
                            objects.append(content)
                        }
                        
                    }
                }
                
                handle(objects)
            }
        }
    }
    
    func getWeatherDataFromURL(coord: CLLocationCoordinate2D,handle: @escaping (_ objects: [WeatherDataContents]) -> Void) {
        let weatherAddress = "https://api.openweathermap.org/data/2.5/weather?lat=\(coord.latitude)&lon=\(coord.longitude)&appid=c19b8e4c8230503901e81ed29c7fa499&units=metric"
        getDataFromURL(from: weatherAddress) { data in
            do {
                var objects: [WeatherDataContents] = [WeatherDataContents]()
                let decoder = JSONDecoder()
                if let weatherData = try? decoder.decode(WeatherData.self, from: data) {
                    
                    let content = WeatherDataContents(temp: weatherData.main.temp, cityID: Int32(weatherData.id), cityName: weatherData.name, weatherID: weatherData.weather[0].id, main: weatherData.weather[0].main, desc: weatherData.weather[0].description, icon: weatherData.weather[0].icon)
                    
                    objects.append(content)
                }
                handle(objects)
            }
        }
    }
    
    private func getDataFromURL(from urlString: String, completion: @escaping(Data) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                guard let data = data else { return }
                completion(data)

            }
        }.resume()
    }
    
}
