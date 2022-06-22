//
//  AreaTableViewCell.swift
//  ParkingLotProject
//
//  Created by 仲輝 on 2022/3/21.
//

import UIKit

class AreaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var areaName: UILabel!

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        changeColor(enabled: highlighted)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        changeColor(enabled: selected)
    }
    
    func changeColor(enabled: Bool) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.contentView.backgroundColor = enabled ? UIColor(red: 0, green: 120, blue: 200, alpha: 0.3) : .clear
        }
    }

}
