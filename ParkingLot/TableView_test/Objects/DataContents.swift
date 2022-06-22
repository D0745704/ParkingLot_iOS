//
//  DataContents.swift
//  TableView_test
//
//  Created by 仲輝 on 2022/3/1.
//

import Foundation
import UIKit

// ParkMessageData
class DataContents: NSObject {
    
    var id: String?
    var area: String?
    var location : String?
    //
    var type: Int16?
    var summ: String?
    var addr: String?
    var tel: String?
    var pay: String?
    var time: String?
    //
    var lat: Double?
    var lng: Double?
    //
    var totalCar: Int16?
    var totalMotor: Int16?
    var totalBike: Int16?
    
    override init() {
        super.init()
    }
    //資料載入DB
    convenience init(id: String, area: String, location: String, type: Int16, summ: String, addr: String, tel: String, pay: String, time: String, lat: Double, lng: Double, totalCar: Int16, totalMotor: Int16, totalBike: Int16) {
        self.init()
        self.id = id
        self.area = area
        self.location = location
        self.type = type
        self.summ = summ
        self.addr = addr
        
        self.tel = tel
        self.pay = pay
        self.time = time
        
        self.lat = lat
        self.lng = lng
        
        self.totalCar = totalCar
        self.totalMotor = totalMotor
        self.totalBike = totalBike
    }
    //顯示給使用者看的
    convenience init(area: String, time: String, addr: String, location: String) {
        self.init()
        self.area = area
        self.time = time
        self.addr = addr
        self.location = location
    }
    //顯示資訊用
    convenience init(area: String, time: String, addr: String, location: String, lat: Double, lng: Double) {
        self.init()
        self.area = area
        self.time = time
        self.addr = addr
        self.location = location
        self.lat = lat
        self.lng = lng
    }
}
/*
 //將textfield 資料 存成String (命名範例) (非實作功能)
 func changeStrings(of _textFields:[UITextField]) -> [String] {
     return []
 }
 */
