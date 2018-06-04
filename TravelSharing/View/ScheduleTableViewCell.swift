//
//  ScheduleTableViewCell.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/2.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit
import SDWebImage

protocol PlayVideoCellProtocol: class {
    func playVideoButtonDidSelect(_ cell: ScheduleTableViewCell, row: Int)
}

class ScheduleTableViewCell: UITableViewCell {

    weak var delegate: PlayVideoCellProtocol?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var leftCellView: UIView!
    @IBOutlet weak var coEditedBtn: UIButton!

    @IBOutlet weak var leftImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        leftCellView.setShadow()
    }

    func updateCell(with schedule: ScheduleInfo) {

        let myDateFormate = schedule.date
        let changeDateFormate = myDateFormate.replacingOccurrences(of: " ", with: ".")

         nameLabel.text = schedule.name
         dateLabel.text = changeDateFormate
         daysLabel.text = schedule.days + "天"
    }

    @IBAction func coEditedBtn(_ sender: UIButton) {

        self.delegate?.playVideoButtonDidSelect(self, row: sender.tag)

//        guard  let allUsersPage = UIStoryboard.allUsersStoryboard().instantiateInitialViewController() else {return}
//
//
//
//        present(allUsersPage, animated: true, completion: nil)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
