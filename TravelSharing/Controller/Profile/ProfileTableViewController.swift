//
//  ProfileTableViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/6/1.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit
import SDWebImage
import Fusuma
import SCLAlertView

class ProfileTableViewController: UITableViewController, FusumaDelegate {
    var getUserInfoManager = GetUserProfileManager()
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var logOutBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        getUserInfoManager.delegate = self
        getUserInfoManager.getMyInfo()
        profileImage.setRounded()
        //        profileImage.clipsToBounds = true
        //        profileImage.layer.cornerRadius = profileImage.frame.width / 2

        logOutBtn.setConerRect()
        saveBtn.setConerRect()
        tableView.separatorStyle = .none

    }

    @IBAction func updateProfileImage(_ sender: Any) {
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusuma.cropHeightRatio = 1
        self.present(fusuma, animated: true, completion: nil)
    }

    @IBAction func saveBtn(_ sender: Any) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )

        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("確定") {
            let imageData = UIImageJPEGRepresentation(self.profileImage.image!, 0.1)
            print(imageData)
            print(self.userNameText.text!)

            self.getUserInfoManager.updateUserInfo(username: self.userNameText.text!, photo: imageData!)
        }

        alertView.addButton("取消") {
        }

        alertView.showSuccess("", subTitle: "更新個人資料?")
    }

    @IBAction func logOutBtn(_ sender: Any) {
        Alertmanager1.shared.showCheck(with: "是否登出", message: "", delete: {
            guard let switchToLoginPage = AppDelegate.shared?.switchToLoginViewController() else {return}
                UserManager.shared.logout()
                switchToLoginPage
        }) {
            print("取消")
        }

    }

    //Fusuma 選照片
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        profileImage.image = image
        profileImage.contentMode = .scaleAspectFill
    }
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {}
    func fusumaVideoCompleted(withFileURL fileURL: URL) {}
    func fusumaCameraRollUnauthorized() {}

}

extension ProfileTableViewController: GetUserInfoManagerDelegate {

    func managerArray(_ manager: GetUserProfileManager, didGet userInfo: [UserInfo]) {}

    func manager(_ manager: GetUserProfileManager, didGet userInfo: UserInfo) {
        userNameText.text = userInfo.userName
        emailLabel.text = userInfo.email
        let url = URL(string: userInfo.photoUrl)
        profileImage.sd_setImage(with: url) { (_, _, _, _) in
            print("yes")
        }
    }
}
