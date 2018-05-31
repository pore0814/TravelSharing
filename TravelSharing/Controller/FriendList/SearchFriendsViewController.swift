//
//  searchFriendsViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/31.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit

class SearchFriendsViewController: UIViewController,UISearchBarDelegate{
    
    @IBOutlet weak var friendSearchBar: UISearchBar!
    var allUserInfo = [UserInfo]()
    var getUserInfoManager = GetUserProfileManager()
    var invitedFriendManager = InvitedFriendsManager()
   
    var searchController = UISearchController()
    var friendInfo:UserInfo?
    var myInfo: UserInfo?
    
    
  
    @IBOutlet weak var addFriendLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserInfoManager.delegate = self
        getUserInfoManager.getAllUserInfo()
        getUserInfoManager.getMyInfo()
        
        friendSearchBar.delegate = self
        friendSearchBar.returnKeyType  = UIReturnKeyType.done
        
      
        
       
    }
 
    
    @IBAction func addFriends(_ sender: Any) {
        guard let friendinfo = friendInfo else {
            AlertToUser().alert.showEdit("aaaa", subTitle: "新先輸入")
            return
        }
        guard let myinfo = myInfo else {return}
        invitedFriendManager.addFriend(myinfo, sendRtoF: friendinfo)
        
    }
    
     func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let friendEmail = friendSearchBar.text
        print(friendEmail)
                for index in 0...allUserInfo.count - 1{
                    if friendEmail! == allUserInfo[index].email {
                        print(allUserInfo[index].email )
                        addFriendLabel.text = allUserInfo[index].email
                        friendInfo =  allUserInfo[index]
                        return
                    }else {
                        addFriendLabel.text = "無資料"
                    }
                }
    }
    

}
extension SearchFriendsViewController: GetUserInfoManagerDelegate {
    func manager(_ manager: GetUserProfileManager, didGet userInfo: UserInfo) {
        myInfo = userInfo
    }
    
    func managerArray(_ manager: GetUserProfileManager, didGet userInfo: [UserInfo]) {
        allUserInfo = userInfo
    }
}
