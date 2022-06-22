//
//  ParkingData.swift
//  TableView_test
//
//  Created by 仲輝 on 2022/2/25.
//

import Foundation

struct ParkingData: Codable {   //API
    
    var ID: String
    var AREA: String
    var NAME: String
    var TYPE: String
    var SUMMARY: String
    var ADDRESS: String
  
    var TEL: String
    var PAYEX: String

    var SERVICETIME: String
    var TW97X: String
    var TW97Y: String
    var TOTALCAR: String
    var TOTALMOTOR: String
    var TOTALBIKE: String
}



/*

 1. Call API, 取得到 ParkJsonObject
 2. ParkJsonObject 轉換成DB的物件, 然後做儲存
 3. 存DB後更新畫面的列表
 
 
 MVVM
 
 */
