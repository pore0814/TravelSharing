//
//  userInfoManager.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/19.
//  Copyright © 2018年 Annie. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

protocol GetUserInfoManagerDelegate: class {
    func manager(_ manager: GetUserInfoManager, didGet userInfo: UserInfo)
}

class GetUserInfoManager {
    var delegate: GetUserInfoManagerDelegate?

// 到FireBase  schedules 撈使用者的post的 Scheudle內容
    func getScheduleContent() {
        guard let userid = UserManager.shared.getFireBaseUID() else {return}
        FireBaseConnect
            .databaseRef
            .child("users")
            .child(userid)
            .observe(.value, with: { (snapshot) in

                if let profileInfo = snapshot.value as?  [String: Any] {
                    let uid = profileInfo["uid"] as? String
                    let email = profileInfo["email"] as? String
                    let photoUrl = profileInfo["photoUrl"] as? String
                    let username = profileInfo["username"] as? String

                    let userProfile = UserInfo(email: email!, photoUrl: photoUrl!, uid: uid!, userName: username!)

                    DispatchQueue.main.async {
                        self.delegate?.manager(self, didGet: userProfile)
                    }
                }
            })
        }

     func updateUserInfo(username: String, photo: Data?) {
        guard let userid = UserManager.shared.getFireBaseUID() else {return}

        //設定image型態
        let metadate = StorageMetadata()
        metadate.contentType = "img/jpeg"

        if let imageData = photo {
            FireBaseConnect.storeageProfileRef.child(userid).putData(imageData, metadata: metadate, completion: { (metadata, imageError) in
                if imageError != nil {
                    guard let imgError = imageError as? String else {return}
                    AlertToUser().alert.showEdit("錯誤訊息", subTitle: imgError)
                }
                if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                    let userData = [Constants.UserName: username, Constants.PhotoUrl: profileImageUrl] as [String: Any]
                    FireBaseConnect.databaseRef.child("users").child(userid).updateChildValues(userData)
                }
            })
        }
    }
    
    func getAllUserInfo(){
        FireBaseConnect.databaseRef.child("users").observe(.value) { (snapshot) in
            if let allUserInfos = snapshot.value as?  [String: Any] {
                print(allUserInfos)
                for allUserInfo in allUserInfos{
//                    print(allUserInfo.value)
//                    if let profileInfo = snapshot.value as?  [String: Any] {
//                        let uid = profileInfo["uid"] as? String
//                        let email = profileInfo["email"] as? String
//                        let photoUrl = profileInfo["photoUrl"] as? String
//                        let username = profileInfo["username"] as? String
//
//                        let userProfile = UserInfo(email: email!, photoUrl: photoUrl!, uid: uid!, userName: username!)
//
//                        DispatchQueue.main.async {
//                            self.delegate?.manager(self, didGet: userProfile)
//                        }
                   // }
                }
                
            }
            
        }
    }
    
}
