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

class ProfileViewController: UIViewController, GetUserInfoManagerDelegate, FusumaDelegate {

    var getUserInfoManager = GetUserInfoManager()
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
         getUserInfoManager.delegate = self
         getUserInfoManager.getScheduleContent()

        let addBarButtonItem = UIBarButtonItem.init(title: "更新·", style: .done, target: self,
                                                    action: #selector(addTapped))
        navigationItem.rightBarButtonItem = addBarButtonItem
    }

    @objc func addTapped(sender: AnyObject) {

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

        alertView.showSuccess("", subTitle: NSLocalizedString("Update personal profile?", comment: ""))
    }

    @IBAction func updateProfileImage(_ sender: Any) {
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusuma.cropHeightRatio = 1
        self.present(fusuma, animated: true, completion: nil)

    }
//Fusuma 選照片
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        profileImage.image = image
        profileImage.contentMode = .scaleAspectFill
    }
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {}
    func fusumaVideoCompleted(withFileURL fileURL: URL) {}
    func fusumaCameraRollUnauthorized() {}

    func manager(_ manager: GetUserInfoManager, didGet userInfo: UserInfo) {
        userNameText.text = userInfo.userName
        emailLabel.text = userInfo.email
        let url = URL(string: userInfo.photoUrl)
        profileImage.sd_setImage(with: url) { (_, _, _, _) in
            print("yes")
        }
    }
//navigation bar ButtonItem

    @IBAction func logOut(_ sender: Any) {
        guard let switchToLoginPage = AppDelegate.shared?.switchToLoginViewController() else {return}
            UserManager.shared.logout()
            switchToLoginPage
        }
    }
