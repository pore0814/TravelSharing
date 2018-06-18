//
//  LogInViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/4/29.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit
import FirebaseAuth
import Crashlytics

class LogInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var holdButtonView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var logInImageView: UIImageView!
     var activeTextfield: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        holdButtonView.setConerRect()

        logInImageView.setConerRect()

    }

    @IBAction func logIn(_ sender: Any) {

        if emailTextField.text != "" && passwordTextField.text != "" {

            UserManager.shared.loginUser(email: emailTextField.text!, password: passwordTextField.text!) { (message) in

                if  message != nil {

                    AlertManager.showEdit(title: Constants.WrongMessage, subTitle: message!)

                } else {

                    guard let passToNextPage = AppDelegate.shared?.switchMainViewController() else {return}

                }
            }
        } else {

            AlertManager.showEdit(title: "", subTitle: Constants.LoginAndRegister.CorrectInfo)

        }
    }

    @IBAction func register(_ sender: Any) {

        let registerPage = UIStoryboard.registerStoryboard().instantiateInitialViewController()

            present(registerPage!, animated: true, completion: nil)

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        self.view.endEditing(true)

    }
}
