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
    static let inValidEmail = "無效Email"
    static let worngPassword = "密碼錯誤"
    static let problemConnecting = "無法連接FireBase"
    static let userNotFound = "無此帳號，請註冊"
    static let weakPassword = "密碼需大於6碼"
    static let emailAlreadyInUse = "此帳號已存在"
}

class UserManager {
    static let shared = UserManager()
    private init () {}

    let userDefaults = UserDefaults.standard
    var destinationManager = DestinationManager()

    var  storeageProfileRef: StorageReference {
        return Storage.storage().reference(forURL: "gs://travelshare-d17da.appspot.com").child(Constants.ProfileImage)
    }

    //登入
    func loginUser(email: String, password: String, loginHandler: LoginHandler?) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
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
    func  singUp(email: String, password: String, username: String, userphoto: Data?, loginHandler: LoginHandler?) {
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
                        guard let imgError = imageError as? String else {return}
                        AlertToUser().alert.showEdit("錯誤訊息", subTitle: imgError)
                    }
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        let userData = [Constants.Uid: uid, Constants.Email: email, Constants.Password: password, Constants.PhotoUrl: profileImageUrl, Constants.UserName: username] as [String: Any]
                             FireBaseConnect.databaseRef.child("users").child(uid).setValue(userData)
                        self.userDefaults.set(uid, forKey: "FireBaseUID")
                        self.userDefaults.synchronize()
//第一筆範例
//                        ScheduleManager.shared.saveScheduleInfo(scheduleName: "範例",
//                                                                scheudleDate: "2019 01 01",
//                                                                scheduleDay: "2")
//                        let  scheduleUid = FireBaseConnect.databaseRef.childByAutoId().key
//                          ScheduleManager.shared.firstScheduleExample(firstScheduleId: scheduleUid, userId: uid)
//                        self.destinationManager.savefisrtDestinationInfo(uid: scheduleUid)

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
                loginHandler?(ErrorCode.worngPassword)
                break
            case .weakPassword:
                loginHandler?(ErrorCode.weakPassword)
                break
            case .invalidEmail:
                loginHandler?(ErrorCode.inValidEmail)
                break
            case .userNotFound:
                loginHandler?(ErrorCode.userNotFound)
                break
            case .emailAlreadyInUse:
                loginHandler?(ErrorCode.emailAlreadyInUse)
                break
            default:
                loginHandler?("請檢查錯誤")
            }
        }
    }

}
