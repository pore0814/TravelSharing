//
//  AllUsersTableViewCell.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/23.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit
import SDWebImage

class AllUsersTableViewCell: UITableViewCell {

    @IBOutlet weak var cancelFriendInvitedBtn: UIButton!
    @IBOutlet weak var allUserNamerLabel: UILabel!
    @IBOutlet weak var allUserEmailLabel: UILabel!
    @IBOutlet weak var allUsersImage: UIImageView!
    @IBOutlet weak var addFriendBtn: UIButton!
    var getUserInfoManager = GetUserProfileManager()
    var getFriendManager = InvitedFriendsManager()
    var userInfo:UserInfo?
    var myInfo:UserInfo?
   
    var invitedFriendManager = InvitedFriendsManager()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        getUserInfoManager.delegate = self
        getUserInfoManager.getMyInfo()
        
       
    }
    
    func getCell(allUsers: UserInfo) {
        userInfo = allUsers
        
        allUserNamerLabel.text = allUsers.userName
        allUserEmailLabel.text = allUsers.email
        let url = URL(string: allUsers.photoUrl)
        allUsersImage.sd_setImage(with: url) { (_, _, _, _) in
            print("yes")
         
        }
        
    }

    @IBAction func addFriendBtn(_ sender:Any) {
        guard let myinfo = myInfo , let friendInfo = userInfo else {return}
     if  !isSelected {
        print("addFriend")
        isSelected = true
        addFriendBtn.isHidden = true
        cancelFriendInvitedBtn.isHidden = false
        print(userInfo?.userName)
        
        invitedFriendManager.sendRequestToFriend(myinfo, sendRtoF: friendInfo)
        
     }else{
        print("deleteFriend")
        isSelected = false
        addFriendBtn.isHidden = false
        cancelFriendInvitedBtn.isHidden = true
           print(userInfo?.userName)

        }
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        
    }
    
}

extension AllUsersTableViewCell:GetUserInfoManagerDelegate{
    func manager(_ manager: GetUserProfileManager, didGet userInfo: UserInfo) {
        myInfo = userInfo
    }
    
    func managerArray(_ manager: GetUserProfileManager, didGet userInfo: [UserInfo]) {
        
    }
    
    
}
