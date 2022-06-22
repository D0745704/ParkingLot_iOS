//
//  AreaViewController.swift
//  ParkingLotProject
//
//  Created by 仲輝 on 2022/3/21.
//

import UIKit

// 1. Protocol
// 2. Callback
// 3. Notification

protocol AreaPopupDelegate {
    func areaSelectedItem(items: [String])
}

class AreaViewController: UIViewController {
    
    //let dbModel = DBModel()
    
    @IBOutlet weak var emptyBackground: UIView!
    @IBOutlet weak var areaTableView: UITableView!
    @IBOutlet weak var areaView: UIView!
    
    var delegate: AreaPopupDelegate?
    var isSelected: ((_ items: [String]) -> Void)?
    
    var area: [String] = [String]()
    var selectItems: [String] = [String]()
    
    let dbModel = DBModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.areaTableView.delegate = self
        self.areaTableView.dataSource = self
        
        area = dbModel.filtArea()
        setAreaView()
    }

    func checkSelectedItem(at indexPath: IndexPath) {
        let item = area[indexPath.row]
        
        if !selectItems.contains(item) {
            selectItems.append(item)
            
        } else {
            let index = selectItems.firstIndex { $0 == item }
            
            if let index = index {
                selectItems.remove(at: index)
            }
        }
    }
    
    func setAreaView() {
        
        areaView.layer.cornerRadius = 10
        areaView.layer.masksToBounds = true
    }
    
    @IBAction func isTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}


extension AreaViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return area.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AreaCell", for: indexPath) as! AreaTableViewCell
        let item = area[indexPath.row]
        
        cell.areaName.text = area[indexPath.item]
                
        let hasItem = selectItems.contains(item)
        cell.accessoryType = hasItem ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        checkSelectedItem(at: indexPath)
        tableView.reloadData()
        
        isSelected?(selectItems)
        
        delegate?.areaSelectedItem(items: selectItems)
    }
}
