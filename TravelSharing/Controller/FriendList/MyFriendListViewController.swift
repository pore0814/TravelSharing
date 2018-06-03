//
//  MyFriendListViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/6/3.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit

class MyFriendListViewController: UIViewController,InvitedFriendsManagerDelegate {
    func manager(_ manager: InvitedFriendsManager, didGet invitedList: [UserInfo]) {
        
    }
    
    func manager(_ manager: InvitedFriendsManager, getPermission permissionList: [UserInfo]) {
        
    }
    
    
    let invitatedFriendManager = InvitedFriendsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        invitatedFriendManager.delegate = self
        invitatedFriendManager.myFriendList()
    }

    

}
