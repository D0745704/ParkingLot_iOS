//
//  ParkingLocTableCell.swift
//  ParkingLotProject
//
//  Created by 仲輝 on 2022/3/10.
//

import UIKit

class ParkingLocTableCell: UITableViewCell {
    
    //停車場名字 地區 地址 服務時間
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var addrLabel: UILabel!
    @IBOutlet weak var servTimeLabel: UILabel!
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        changeColor(enabled: highlighted)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        changeColor(enabled: selected)
    }
    
    func changeColor(enabled: Bool) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.contentView.backgroundColor = enabled ? UIColor(red: 0, green: 0, blue: 255, alpha: 0.3) : .clear
        }
    }
}
