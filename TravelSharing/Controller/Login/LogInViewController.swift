//
//  LogInViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/4/29.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var holdButtonView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var activeTextfield: UITextField!

    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var logInImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
      holdButtonView.setConerRect()
        logInImageView.setConerRect()

//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    /*
    @objc func keyboardNotification(notification: NSNotification) {
//        if let userInfo = notification.userInfo {
//            let keyboardFrame: CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//            let duration: Double = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
//
//            UIView.animate(withDuration: duration, animations: { () -> Void in
//                var frame = self.view.frame
//                frame.origin.y = keyboardFrame.minY - self.view.frame.height
//                self.view.frame = frame
//            })
//        }
        let info:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardY = self.view.frame.size.height - keyboardSize.height
        
        let editingTextFieldY:CGFloat! = self.activeTextfield.frame.origin.y
        if editingTextFieldY > keyboardY - 60 {
            UIView.animate(withDuration: 0.25, delay: 0.0, options:  UIViewAnimationOptions.curveEaseIn, animations: {
               self.view.frame = CGRect(x: 0, y: self.view.frame.origin.y - (editingTextFieldY! - (keyboardY - 60)), width: self.view.bounds.width, height: self.view.bounds.height)
            }, completion: nil)
        }
    }
*/

    @IBAction func logIn(_ sender: Any) {

        if emailTextField.text != "" && passwordTextField.text != "" {

            UserManager.shared.loginUser(email: emailTextField.text!, password: passwordTextField.text!) { (message) in
                if  message != nil {
                      AlertToUser().alert.showError(Constants.WrongMessage, subTitle: message!)
                } else {
                   // passToNextPage
                   guard let passToNextPage = AppDelegate.shared?.switchMainViewController() else {return}
                }
            }
        } else {
            AlertToUser().alert.showEdit("請填寫表格", subTitle: "填寫正確的Email和密碼")
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
