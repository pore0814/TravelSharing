//
//  FriendListViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/31.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit

class FriendListViewController: UIViewController {
    
    var invitedFriendsManager = InvitedFriendsManager()
   
    var myInfo:UserInfo?

    override func viewDidLoad() {
        super.viewDidLoad()
       
    
       
    }

    @IBAction func addFriends(_ sender: Any) {
        print("Aaaaaaaaaddfriends")
//        
//            guard let allUserVC = UIStoryboard(name: "FriendsList", bundle: nil).instantiateInitialViewController as? SearchFriendsViewController else {return}
//            self.navigationController?.pushViewController(allUserVC, animated: true)
//        guard let allUserVC = UIStoryboard(name: "FriendsList", bundle: nil).instantiateInitialViewController as? InvitedListViewController else {return}
//                self.navigationController?.pushViewController(allUserVC, animated: true)
    }
}


extension FriendListViewController: GetUserInfoManagerDelegate{
    func managerArray(_ manager: GetUserProfileManager, didGet userInfo: [UserInfo]) {}
    
    func manager(_ manager: GetUserProfileManager, didGet userInfo: UserInfo) {
       myInfo = userInfo
        }
    }




