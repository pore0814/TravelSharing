//
//  InviteFriendsViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/22.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit

class InviteFriendsViewController: UIViewController {
     let getUserInfoManager = GetUserInfoManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        getUserInfoManager.getAllUserInfo()
        print("invite")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
