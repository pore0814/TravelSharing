//
//  ProfileViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/4/29.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func logOut(_ sender: Any) {
        guard let switchToLoginPage = AppDelegate.shared?.switchToLoginViewController() else {return}
        UserManager.shared.logout()
        switchToLoginPage
    }

}
