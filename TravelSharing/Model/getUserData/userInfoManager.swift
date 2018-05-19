//
//  userInfoManager.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/19.
//  Copyright © 2018年 Annie. All rights reserved.
//

import Foundation

protocol GetUserInfoManagerDelegate:class {
    func manager(_ manager:GetUserInfoManager,didGet userInfo: UserInfo)
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
    }
