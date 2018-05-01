//
//  FireBase.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/4/29.
//  Copyright © 2018年 Annie. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

typealias LoginHandler = (_ msg:String?) -> Void

struct LoginErrorCode{
    static let Invalid_Email = "Invalid Email Address，PleaseProvide A Real Email Address"
    static let Worng_Password = "Wrong Password, Please Enter the Correct Password"
    static let Problem_Connecting = "Problem Connecting to Deatabase"
    static let User_not_Found = "User Not Found, Please Register"
    static let Weak_Password = "Password Should be At Least 6 Characters Long"
    static let Email_Already_In_Use = "Email Already in Use, Please Use Another Email"
}


class UserManager {
    static let shared = UserManager()
    private init (){}
    
    
    func loginUser(email: String, password: String, loginHandler: LoginHandler?) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            Auth.auth().currentUser?.createProfileChangeRequest()
            if  error  != nil {
                self.handleErrors(err: error! as NSError, loginHandler: loginHandler)
            }else {
                loginHandler?(nil)
            }
        }
    }
    
    
    func  SingUp(email: String, password: String,username:String,photoURL:String, loginHandler: LoginHandler?) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil  {//有錯
                self.handleErrors(err: error! as NSError, loginHandler: loginHandler)
            }else {
                
                let userData = ["uid":user?.uid, "email":email,"username":username,"userPhote":photoURL]
                FireBaseRef.userInfoRef.setValue(userData)
                UserDefaults.standard.set(user?.uid, forKey: "userId")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    
    
    
    // 錯誤處理
    private func handleErrors(err:NSError, loginHandler: LoginHandler?){
        
        if let errCode = AuthErrorCode(rawValue: err.code){
            switch errCode {
            case .wrongPassword:
                loginHandler?(LoginErrorCode.Worng_Password)
                break
            case .weakPassword:
                loginHandler?(LoginErrorCode.Weak_Password)
                break
            case .invalidEmail:
                loginHandler?(LoginErrorCode.Invalid_Email)
                break
            case .userNotFound:
                loginHandler?(LoginErrorCode.User_not_Found)
                break
            case .emailAlreadyInUse:
                loginHandler?(LoginErrorCode.Email_Already_In_Use)
                break
            default:
                break
            }
        }
    }
    
    
    struct FireBaseRef {
        static let userInfoRef = Database.database().reference().child("users")
        
    }
    
}
