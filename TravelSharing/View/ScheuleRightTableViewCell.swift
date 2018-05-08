//
//  ScheuleRightTableViewCell.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/3.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit

class ScheuleRightTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var daysLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
