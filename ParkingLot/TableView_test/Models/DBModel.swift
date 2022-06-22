//
//  DBModel.swift
//  TableView_test
//
//  Created by 仲輝 on 2022/2/25.
//

import UIKit
import CoreData

class DBModel: NSObject {
    var parkingList: [Parking] = []
    let parkingDB = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override init() {
        super.init()
    }
    
    func insertObjects(data: DataContents) {

        let parking = NSEntityDescription.insertNewObject(forEntityName: "Parking", into: self.parkingDB) as! Parking
        let request = NSFetchRequest<Parking>(entityName: "Parking")
        do {
            let datalist = try parkingDB.fetch(request)
            request.predicate = NSPredicate(format: "id CONTAINS %@", data.id!)
            
            let duplicateData = try parkingDB.fetch(request)
            //else 取代
            if duplicateData.isEmpty {
                parking.id = data.id
                parking.area = data.area
                parking.loc = data.location
                //
                parking.type = data.type!
                parking.summary = data.summ
                parking.addr = data.addr
                parking.tel = data.tel
                parking.payex = data.pay
                parking.servTime = data.time
                //
                parking.latitude = data.lat!
                parking.longitude = data.lng!
                //
                parking.totalCar = data.totalCar!
                parking.totalMotor = data.totalMotor!
                parking.totalBike = data.totalBike!
                try self.parkingDB.save()
            } else {
                for index in datalist {
                    if index.id == data.id {
                        //舊的先刪掉
                        parkingDB.delete(index)
                        //再把新的加進來
                        parking.id = data.id
                        parking.area = data.area
                        parking.loc = data.location
                        //
                        parking.type = data.type!
                        parking.summary = data.summ
                        parking.addr = data.addr
                        parking.tel = data.tel
                        parking.payex = data.pay
                        parking.servTime = data.time
                        //
                        parking.latitude = data.lat!
                        parking.longitude = data.lng!
                        //
                        parking.totalCar = data.totalCar!
                        parking.totalMotor = data.totalMotor!
                        parking.totalBike = data.totalBike!
                        try parkingDB.save()
                        break
                    }
                }
            }
        } catch {
            print("data insert error")
        }
    }
    
    //資料刪除
    func deleteObject(at indexPath: IndexPath) {
       
        let request = NSFetchRequest<Parking>(entityName: "Parking")
        
        do {
            let results = try self.parkingDB.fetch(request)
            
            for item in results {
                if item.id == self.parkingList[indexPath.row].id {
                    parkingDB.delete(item)
                    break
                }
            }
            
            try self.parkingDB.save()
      
        } catch {
            fatalError("Failed to fetch data: \(error)")
        }
    }
        
    //資料修改
    func modifyObject(at indexPath: IndexPath, data: DataContents, show: @escaping(_ list: Bool) -> Void)  {
      
        var list: Bool = false
        let request = NSFetchRequest<Parking>(entityName: "Parking")
        do {
            let results = try self.parkingDB.fetch(request)
            // NSPredicated
            request.predicate = NSPredicate(format: "addr CONTAINS %@ OR loc CONTAINS %@", data.addr!, data.location!)
            let duplicateData = try parkingDB.fetch(request)
            //
            if duplicateData.isEmpty {
                results[indexPath.row].area = data.area
                results[indexPath.row].servTime = data.time
                results[indexPath.row].addr = data.addr
                results[indexPath.row].loc = data.location
                list = true
            }
            
            try self.parkingDB.save()
            show(list)
        } catch let error {
            dump(error)
        }
    }
    
    //資料查詢
    func showObjects(by datas: [String]) {
        var parkingMessageData: [Parking] = []
        let request = NSFetchRequest<Parking>(entityName: "Parking")
        do {
            let results = try parkingDB.fetch(request)
            //篩選結果
            if datas.isEmpty {
                for result in results {
                    
                    parkingMessageData.append(result)
                }
            } else {
                for result in results {
                    if datas.contains(result.area!) {
                        
                        parkingMessageData.append(result)
                    }
                }
            }
        } catch {
            fatalError("Failed to fetch data: \(error)")
        }
        
        self.parkingList = parkingMessageData
    }
    
    //MARK: - 其他功能
    
    //過濾地區
    func filtArea() -> [String] {
        
        var areaArr:[String] = []
        let request = NSFetchRequest<Parking>(entityName: "Parking")
        
        do {
            let results = try parkingDB.fetch(request)
            results.forEach { result in
                if result.area != nil {
                    areaArr.append(result.area!)
                }
            }
        } catch {
            fatalError("Failed to fetch data: \(error)")
        }
        areaArr = areaArr.uniqued().sorted()
        return areaArr
    }
}


extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
//MARK: - filter用法
/*
# filter
let filterResults = results.filter{ result in
    let condition =
        result.area == data.area &&
        result.servTime == data.time &&
        result.addr == data.addr &&
        result.loc == data.location
    return condition
}
if filterResults.isEmpty {
    parking.area = data.area
    parking.servTime = data.time
    parking.addr = data.addr
    parking.loc = data.location
    parking.dataType = data.type!
    
} else {
    return false
}
 */
/*
 1. 物件導向 k
 2. filter 調整 k
 3. 新增 k 修改 k 刪除 查詢 都用物件處理
 4. 方法命名要有動詞開頭, 變數命名不可有動詞開頭 k
 */
