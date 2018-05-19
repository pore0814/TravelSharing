//
//  ProfileViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/4/29.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit
import SDWebImage


class ProfileViewController: UIViewController,GetUserInfoManagerDelegate {

    var getUserInfoManager = GetUserInfoManager()
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         getUserInfoManager.delegate = self
         getUserInfoManager.getScheduleContent()
    }

    func manager(_ manager: GetUserInfoManager, didGet userInfo: UserInfo) {
        userNameText.text = userInfo.userName
        emailLabel.text = userInfo.email
        let url = URL(string: userInfo.photoUrl)
        profileImage.sd_setImage(with: url) { (image, error, cach, url) in
            print("yes")
        }
    }

    @IBAction func logOut(_ sender: Any) {
        guard let switchToLoginPage = AppDelegate.shared?.switchToLoginViewController() else {return}
            UserManager.shared.logout()
            switchToLoginPage
        }
    }
