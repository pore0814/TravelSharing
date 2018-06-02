//
//  searchFriendsViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/31.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit
import SDWebImage

class SearchFriendsViewController: UIViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource{
    
   
    
    
    @IBOutlet weak var friendSearchBar: UISearchBar!
    var allUserInfo = [UserInfo]()
    var getUserInfoManager = GetUserProfileManager()
    var invitedFriendManager = InvitedFriendsManager()
   
    var searchController = UISearchController()
    var friendInfo:UserInfo?
    var myInfo: UserInfo?
    var invitate = [WaitingList]()
    
    @IBOutlet weak var addFriendsBtn: UIButton!
  
    @IBOutlet weak var waitingtableView: UITableView!
    
  
    @IBOutlet weak var addFriendLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserInfoManager.delegate = self
        getUserInfoManager.getAllUserInfo()
        getUserInfoManager.getMyInfo()
        
        invitedFriendManager.delegate = self
        invitedFriendManager.requestsList()
        
        friendSearchBar.delegate = self
        friendSearchBar.returnKeyType  = UIReturnKeyType.done
        
        
      waitingtableView.dataSource = self
      waitingtableView.delegate = self
      let nib  = UINib(nibName: "AllUsersTableViewCell", bundle: nil)
        waitingtableView.register(nib, forCellReuseIdentifier: "AllUsersTableViewCell")
        invitedFriendManager.requestsList()
       
    }
 
    
    @IBAction func addFriends(_ sender: Any) {
        guard let friendinfomation = friendInfo else {return}

                guard let myinfo = myInfo else {return}
                invitedFriendManager.sendRequestToFriend(myinfo, sendRtoF: friendinfomation)
                invitedFriendManager.sendWaitingRequestToFriend(myinfo, sendRtoF: friendinfomation)
                addFriendsBtn.isHidden = true
            }
  
    
     func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let friendEmail = friendSearchBar.text
        print(friendEmail)
                for index in 0...allUserInfo.count - 1{
                    if friendEmail! == allUserInfo[index].email {
                        addFriendLabel.text = allUserInfo[index].email
                        friendInfo =  allUserInfo[index]
                         addFriendsBtn.isHidden = false
                        return
                    }else {
                        addFriendLabel.text = "無資料"
                    }
                }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invitate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AllUsersTableViewCell") as? AllUsersTableViewCell else {return UITableViewCell()}
        cell.allUserEmailLabel.text = invitate[indexPath.row].email
        cell.allUserNamerLabel.text = invitate[indexPath.row].userName
        cell.allUsersImage.sd_setImage(with:URL(string: invitate[indexPath.row].photoUrl), completed: nil)
        cell.addFriendBtn.setTitle("取消", for: .normal)
//        cell.addFriendBtn.isHidden = false
        cell.cancelFriendInvitedBtn.isHidden = false
        
        cell.cancelFriendInvitedBtn.addTarget(self, action:#selector(cancel(sender:)), for: .touchUpInside)
        return cell
    }
    
    
    @objc func cancel(sender:UIButton){
        print("abc")
    }
    

}
extension SearchFriendsViewController: GetUserInfoManagerDelegate , InvitedFriendsManagerDelegate{
    func manager(_ manager: InvitedFriendsManager, didGet invitedList: [WaitingList]) {
        invitate = invitedList
        waitingtableView.reloadData()
    }
    
   
    func manager(_ manager: GetUserProfileManager, didGet userInfo: UserInfo) {
        myInfo = userInfo
    }
    
    func managerArray(_ manager: GetUserProfileManager, didGet userInfo: [UserInfo]) {
        allUserInfo = userInfo
    }
    
  
    
    
}
