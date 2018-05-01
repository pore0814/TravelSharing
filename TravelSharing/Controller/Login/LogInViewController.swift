//
//  LogInViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/4/29.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


    @IBAction func logIn(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text != "" {
            UserManager.shared.loginUser(email: emailTextField.text!, password: passwordTextField.text!) { (message) in
                if message != nil {
                    self.alerTheUser(title: "Problem with Authentication", message: message!)
                }else{
                    print("Login completed")
                }
            }

        }else {
           alerTheUser(title: "Email and Password are Required", message: "Please enter email and pasword in the text fields")
        }
    }
    
    @IBAction func register(_ sender: Any) {
         let a = UIStoryboard.registerStoryboard().instantiateInitialViewController()
       present(a!, animated: true, completion: nil)
    }
    
    
     func alerTheUser(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
}
