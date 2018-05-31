//
//  searchFriendsViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/31.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit

class SearchFriendsViewController: UIViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AllUsersTableViewCell") as? AllUsersTableViewCell else {return UITableViewCell()}
        return cell
    }
    
    
    @IBOutlet weak var friendSearchBar: UISearchBar!
    var allUserInfo = [UserInfo]()
    var getUserInfoManager = GetUserProfileManager()
    var invitedFriendManager = InvitedFriendsManager()
   
    var searchController = UISearchController()
    var friendInfo:UserInfo?
    var myInfo: UserInfo?
    
    @IBOutlet weak var addFriendsBtn: UIButton!
  
    @IBOutlet weak var waitingtableView: UITableView!
    
  
    @IBOutlet weak var addFriendLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserInfoManager.delegate = self
        getUserInfoManager.getAllUserInfo()
        getUserInfoManager.getMyInfo()
        
        friendSearchBar.delegate = self
        friendSearchBar.returnKeyType  = UIReturnKeyType.done
        
        
      waitingtableView.dataSource = self
      waitingtableView.delegate = self
      let nib  = UINib(nibName: "AllUsersTableViewCell", bundle: nil)
        waitingtableView.register(nib, forCellReuseIdentifier: "AllUsersTableViewCell")
        
       
    }
 
    
    @IBAction func addFriends(_ sender: Any) {
        guard let friendinfo = friendInfo else {
            AlertToUser().alert.showEdit("", subTitle: "新先輸入")
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
                         addFriendsBtn.isHidden = false
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
