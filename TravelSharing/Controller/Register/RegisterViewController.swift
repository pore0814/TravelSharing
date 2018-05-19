//
//  RegisterViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/4/30.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit
import FirebaseAuth
import Fusuma

class RegisterViewController: UIViewController, FusumaDelegate {

    @IBOutlet weak var photoBtn: UIButton!
    @IBOutlet weak var registImageView: UIImageView!
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!

    @IBOutlet weak var reEnterPasswordText: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        registImageView.setCircle()
        photoBtn.isUserInteractionEnabled = true

      //換頁notification
        NotificationCenter.default.addObserver(self, selector: #selector(toMainPage), name: .switchtoMainPage, object: nil)
    }

    @objc func toMainPage(notification: Notification) {
        guard let switchMainPage = AppDelegate.shared?.switchMainViewController() else {return}
    }

    //Fusuma
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        registImageView.image = image
        registImageView.contentMode = .scaleAspectFill
    }
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {}
    func fusumaVideoCompleted(withFileURL fileURL: URL) {}
    func fusumaCameraRollUnauthorized() {}

    //ChoosePhoto
    @IBAction func uploadProfile(_ sender: Any) {
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusuma.cropHeightRatio = 1
        self.present(fusuma, animated: true, completion: nil)
    }

    //Register
    @IBAction func registerBtn(_ sender: Any) {

        guard let imageCheck = registImageView.image else {
              AlertToUser().alert.showEdit("", subTitle: "請選擇照片哦")
            return
        }
        let data = UIImageJPEGRepresentation(imageCheck, 0.1)

    //表格需全部填寫
        if userNameText.text != "", emailText.text != "", passwordText.text != "", reEnterPasswordText.text != "" {
         //密碼需大於六碼
            if (passwordText.text?.count)! < 6 {
                  AlertToUser().alert.showEdit(Constants.WrongMessage, subTitle: ">6")
        //密碼與再次確認密碼
            } else if passwordText.text != reEnterPasswordText.text {
                AlertToUser().alert.showEdit(Constants.WrongMessage, subTitle: "二個密碼不同")
        //Email格式
            } else if emailText.text!.isEmail == false {
                AlertToUser().alert.showEdit(Constants.WrongMessage, subTitle: "無效Email")
        //開始註冊＋FireBaseApi Error檢查
            } else {
              UserManager.shared.singUp(email: emailText.text!, password: passwordText.text!, username: userNameText.text!, userphoto: data) { (message) in
                         AlertToUser().alert.showEdit(Constants.WrongMessage, subTitle: message!)
                }
            }
        } else {
              AlertToUser().alert.showEdit("請填寫完整", subTitle: "所有空格都需填寫")

        }
    }

    // Cancel
    @IBAction func cancelBtn(_ sender: Any) {
       dismiss(animated: true, completion: nil)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
