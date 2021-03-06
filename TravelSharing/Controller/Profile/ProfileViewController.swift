//
//  ProfileViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/4/29.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit
import SDWebImage
import Fusuma
import SCLAlertView

class ProfileViewController: UIViewController, FusumaDelegate {

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

         logOutBtn.setConerRect()

         saveBtn.setConerRect()
    }

    @IBAction func updateProfileImage(_ sender: Any) {

        let fusuma = FusumaViewController()

        fusuma.delegate = self

        fusuma.cropHeightRatio = 1

        self.present(fusuma, animated: true, completion: nil)

    }

    @IBAction func saveBtn(_ sender: Any) {

        Alertmanager1.shared.showCheck(with: "更新個人資料?", message: "", delete: {

            let imageData = UIImageJPEGRepresentation(self.profileImage.image!, 0.1)

            self.getUserInfoManager.updateUserInfo(username: self.userNameText.text!, photo: imageData!)

        }) {

            print("取消")

        }
    }

    @IBAction func logOutBtn(_ sender: Any) {

        Alertmanager1.shared.showCheck(with: "aaa", message: "", delete: {

            guard let switchToLoginPage = AppDelegate.shared?.switchToLoginViewController() else {return}

            UserManager.shared.logout()

        }) {

            print("登出")

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

extension ProfileViewController: GetUserInfoManagerDelegate {

    func managerArray(_ manager: GetUserProfileManager, didGet userInfo: [UserInfo]) {}

    func manager(_ manager: GetUserProfileManager, didGet userInfo: UserInfo) {

        userNameText.text = userInfo.userName

        emailLabel.text = userInfo.email

        let url = URL(string: userInfo.photoUrl)

        profileImage.sd_setImage(with: url) { (_, _, _, _) in

        }
      }
    }
