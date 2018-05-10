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
import FirebaseStorage

typealias LoginHandler = (_ msg: String?) -> Void

struct ErrorCode {
    static let Invalid_Email = "無效Email"
    static let Worng_Password = "密碼錯誤"
    static let Problem_Connecting = "無法連接FireBase"
    static let User_not_Found = "無此帳號，請註冊"
    static let Weak_Password = "密碼需大於6碼"
    static let Email_Already_In_Use = "此帳號已存在"
}




class UserManager {
    static let shared = UserManager()
    //static let uuid = UserDefaults.standard.string(forKey: "FireBaseUID")
    private init () {}

    let userDefaults = UserDefaults.standard

    var  storeageProfileRef: StorageReference {
        return Storage.storage().reference(forURL: "gs://travelshare-d17da.appspot.com").child(Constants.Profile_image)
    }

    //登入
    func loginUser(email: String, password: String, loginHandler: LoginHandler?) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in

          //  Auth.auth().currentUser?.createProfileChangeRequest()
            if  error  != nil {
                self.handleErrors(err: error! as NSError, loginHandler: loginHandler)

            } else {
                loginHandler?(nil)
                self.userDefaults.set(user?.uid, forKey: "FireBaseUID")
                self.userDefaults.synchronize()
            }
        }
    }

    //註冊
    func  SingUp(email: String, password: String, username: String, userphoto: Data?, loginHandler: LoginHandler?) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                self.handleErrors(err: error! as NSError, loginHandler: loginHandler)
                return
            }
            guard let uid = user?.uid else {return}

            //設定image型態
            let metadate = StorageMetadata()
            metadate.contentType = "img/jpeg"

            if let imageData = userphoto {
                self.storeageProfileRef.child(uid).putData(imageData, metadata: metadate, completion: { (metadata, imageError) in
                    if imageError != nil {
                        AlertToUser.shared.alerTheUserPurple(title: "錯誤訊息", message: imageError as! String)
                        
                    }
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        let userData = [Constants.Uid: uid, Constants.Email: email, Constants.Password: password, Constants.PhotoUrl: profileImageUrl, Constants.UserName: username] as [String: Any]
                             FireBaseConnect.databaseRef.child("users").child(uid).setValue(userData)
                        self.userDefaults.set(uid, forKey: "FireBaseUID")
                        self.userDefaults.synchronize()
                       NotificationCenter.default.post(name: .switchtoMainPage, object: nil)
                    }
                })
            }
        }
    }

    // 登出
    func logout() {
        guard (UserDefaults.standard.value(forKey: "FireBaseUID") as? String) != nil else {return}
        try? Auth.auth().signOut()
        UserDefaults.standard.removeObject(forKey: "FireBaseUID")
    }

    //uid token
    func getFireBaseUID() -> String? {
        return UserDefaults.standard.string(forKey: "FireBaseUID")
    }

    // 錯誤處理
    private func handleErrors(err: NSError, loginHandler: LoginHandler?) {

        if let errCode = AuthErrorCode(rawValue: err.code) {
            switch errCode {
            case .wrongPassword:
                loginHandler?(ErrorCode.Worng_Password)
                break
            case .weakPassword:
                loginHandler?(ErrorCode.Weak_Password)
                break
            case .invalidEmail:
                loginHandler?(ErrorCode.Invalid_Email)
                break
            case .userNotFound:
                loginHandler?(ErrorCode.User_not_Found)
                break
            case .emailAlreadyInUse:
                loginHandler?(ErrorCode.Email_Already_In_Use)
                break
            default:
                break
            }
        }
    }

}
