//
//  searchFriendsViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/31.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit

class SearchFriendsViewController: UIViewController {
    
    var allUserInfo = [UserInfo]()
    var getUserInfoManager = GetUserProfileManager()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserInfoManager.delegate = self
        getUserInfoManager.getAllUserInfo()
    }

}
extension SearchFriendsViewController: GetUserInfoManagerDelegate {
    func manager(_ manager: GetUserProfileManager, didGet userInfo: UserInfo) {}
    
    func managerArray(_ manager: GetUserProfileManager, didGet userInfo: [UserInfo]) {
        print(allUserInfo)
        allUserInfo = userInfo
    }
}
