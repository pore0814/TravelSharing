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

class RegisterViewController: UIViewController,FusumaDelegate{

    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        registImageView.image = image
        registImageView.contentMode = .scaleAspectFill
    }
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {}
    func fusumaVideoCompleted(withFileURL fileURL: URL) {}
    func fusumaCameraRollUnauthorized() {}
        
    
    
    @IBOutlet weak var registImageView: UIImageView!
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func uploadProfile(_ sender: Any) {
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusuma.cropHeightRatio = 1
        self.present(fusuma, animated: true, completion: nil)
       
       
      
    }
    
  
    
    
    @IBAction func registerBtn(_ sender: Any) {
        guard  let data = UIImageJPEGRepresentation(registImageView.image!, 0.9) else {return}
        if userNameText.text != "" , emailText.text != "", passwordText.text != "" {
            UserManager.shared.SingUp(email: emailText.text!, password: passwordText.text!, username: userNameText.text!, photoURL: "not yet") { (message) in
                if (self.emailText.text?.isValidEmail())! && (self.passwordText.text?.count)! > 6  {
                    print("email Ok")
                }else {
                    print("不ok")
                }
                
               // self.alerTheUser(title: "Problem with SignIN", message: message!)
            }
        }else{
            alerTheUser(title: "All require", message: "please enter all Textfield")
        }
    }
    

    
    
    @IBAction func cancelBtn(_ sender: Any) {
        
    }
    
    func alerTheUser(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
}
