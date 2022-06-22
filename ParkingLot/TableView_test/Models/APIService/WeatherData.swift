//
//  WeatherData.swift
//  ParkingLotProject
//
//  Created by 仲輝 on 2022/3/28.
//

import Foundation

struct WeatherData: Codable {
    var coord: Coordinate //座標
    var weather: [AreaWeather] //天氣
    var main: Main //只取溫度先
    var id: Int //城市ID
    var name: String //城市名稱
}

struct Coordinate: Codable {
    var lon: Double
    var lat: Double
}

struct AreaWeather: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

struct Main: Codable {
    
    var temp: Double
//    var feelsLike: Double
//    var tempMin: Double
//    var tempMax: Double
//    var pressure: Int
//    var humidity: Int
    
//    enum CodingKeys: String,CodingKey {
//        case temp
//        case feelsLike = "feels_like"
//        case tempMin = "temp_min"
//        case tempMax = "temp_max"
//        case pressure
//        case humidity
//    }
}
