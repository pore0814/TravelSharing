//
//  CustomCell.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/2.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CustomCell: JTAppleCell {
    @IBOutlet weak var datelabe: UILabel!
    @IBOutlet weak var selecetedView: UIView!
    
    override func awakeFromNib() {
        selecetedView.setCircle()
        selecetedView.backgroundColor = UIColor.white
    }

    
}
