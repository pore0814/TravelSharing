//
//  AllUsersTableViewCell.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/23.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit
import SDWebImage

class AllUsersTableViewCell: UITableViewCell {

    @IBOutlet weak var allUserNamerLabel: UILabel!
    @IBOutlet weak var allUserEmailLabel: UILabel!
    @IBOutlet weak var allUsersImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func getCell(allUsers: UserInfo) {
        allUserNamerLabel.text = allUsers.userName
        allUserEmailLabel.text = allUsers.email
        let url = URL(string: allUsers.photoUrl)
        allUsersImage.sd_setImage(with: url) { (_, _, _, _) in
            print("yes")
        }
    }

    }
