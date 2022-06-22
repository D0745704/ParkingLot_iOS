//
//  WeatherDataContents.swift
//  ParkingLotProject
//
//  Created by 仲輝 on 2022/3/30.
//
import Foundation
import UIKit

class WeatherDataContents: NSObject {
    
    var temp: Double?
    
    var cityID: Int32?
    var cityName: String?
    //weather
    var weatherID: Int16?
    var main: String?
    var desc: String?
    var icon: String?
    
    override init() {
        super.init()
    }
    
    convenience init(temp: Double, cityID: Int32, cityName: String, weatherID: Int, main: String, desc: String, icon: String) {
        
        self.init()
        
        self.temp = temp
        
        self.cityID = cityID
        self.cityName = cityName
        
        self.weatherID = Int16(weatherID)
        self.main = main
        self.desc = desc
        self.icon = icon
    }
}
