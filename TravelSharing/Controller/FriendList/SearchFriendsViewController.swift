//
//  searchFriendsViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/31.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit
import SDWebImage

class SearchFriendsViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var friendSearchBar: UISearchBar!
    var allUserInfo = [UserInfo]()
    var friendsArray = [UserInfo]()
    var getUserInfoManager = GetUserProfileManager()
    var invitedFriendManager = InvitedFriendsManager()

    var searchController = UISearchController()
    var friendInfo: UserInfo?
    var myInfo: UserInfo?
    var invitate = [UserInfo]()
    var friendEmail:String?

    @IBOutlet weak var addFriendsBtn: UIButton!

    @IBOutlet weak var waitingtableView: UITableView!

    @IBOutlet weak var friendProfileImg: UIImageView!
    @IBOutlet weak var friendUserNamerLabel: UILabel!
    @IBOutlet weak var friendEmailLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        configureModelManager()

        configureSearchBar()

        setupTableView()

        addFriendsBtn.setRounded10()
    }

    func configureModelManager() {
        getUserInfoManager.delegate = self
        getUserInfoManager.getAllUserInfo()
        getUserInfoManager.getMyInfo()

        invitedFriendManager.delegate = self
        invitedFriendManager.requestsFromMeList()
        invitedFriendManager.myFriendList()
    }
  
    func configureSearchBar() {
        friendSearchBar.delegate = self
        friendSearchBar.returnKeyType  = UIReturnKeyType.done
    }

    func setupTableView() {
        waitingtableView.dataSource = self
        waitingtableView.delegate = self

        let nib  = UINib(nibName: "AllUsersTableViewCell", bundle: nil)
        waitingtableView.register(nib, forCellReuseIdentifier: "AllUsersTableViewCell")
    }

//加朋友Query
    @IBAction func addFriends(_ sender: Any) {
        guard let friendinfomation = friendInfo else {return}
        
        guard let myinfo = myInfo else {return}
        
        if friendsArray.count >  0 {
        for index in 0...friendsArray.count - 1 {
    //是否就有在朋友列表內，如果有就Alert，沒有就丟到列表
            if friendEmail! == friendsArray[index].email {
               AlertManager.showError(title: "你們已經是朋友了", subTitle: "")
               return
            } else {
                invitedFriendManager.sendRequestToFriend(myinfo, sendRtoF: friendinfomation)
                invitedFriendManager.waitingPermission(myinfo, sendRtoF: friendinfomation)
                addFriendsBtn.isHidden = true
                friendEmailLabel.text = ""
                friendUserNamerLabel.text = ""
                friendProfileImg.isHidden =  true
                
            }
        }
     }
    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        searchBar.resignFirstResponder()
        return true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
// 搜尋好友
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        friendEmail = friendSearchBar.text

        friendSearchBar.enablesReturnKeyAutomatically = true
        friendSearchBar.resignFirstResponder()
        friendSearchBar.showsCancelButton = true
        
        for index in 0...allUserInfo.count - 1 {
            //搜詢的Eamil，在所有使用者裡看看。
            if friendEmail! == allUserInfo[index].email  {
                if  isFriendArry(friendemail: friendEmail!) == true {
                    friendEmailLabel.text = allUserInfo[index].email
                    friendUserNamerLabel.text = allUserInfo[index].userName
                    friendProfileImg.sd_setImage(with: URL(string: allUserInfo[index].photoUrl), completed: nil)
                    friendInfo =  allUserInfo[index]
                    addFriendsBtn.isHidden = false
                    searchBar.text = ""
                    return
                }
            } else {
                friendEmailLabel.text = "無資料"
            }
        }
    }
    
    func isFriendArry(friendemail:String) -> Bool{
        for index in 0...friendsArray.count - 1 {
            //是否就有在朋友列表內，如果有就Alert，沒有就丟到列表
            if friendEmail == friendsArray[index].email {
                AlertManager.showError(title: "你們已經是朋友了", subTitle: "")
                return false
            }
        }
        return true
    }
    
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(invitate.count)
        return invitate.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AllUsersTableViewCell") as? AllUsersTableViewCell else {return UITableViewCell()}
        
            cell.allUserEmailLabel.text = invitate[indexPath.row].email
            cell.allUserNamerLabel.text = invitate[indexPath.row].userName
            cell.allUsersImage.sd_setImage(with: URL(string: invitate[indexPath.row].photoUrl), completed: nil)
            cell.addFriendBtn.setTitle("取消", for: .normal)
            cell.cancelFriendInvitedBtn.isHidden = false
            cell.cancelFriendInvitedBtn.addTarget(self, action: #selector(cancel(sender:)), for: .touchUpInside)
        
        return cell
    }

//取消
    @objc func cancel(sender: UIButton) {
        invitedFriendManager.cancelPermission(friendID: invitate[sender.tag].uid)
        invitedFriendManager.cancelRequestFromMe(friendID: invitate[sender.tag].uid)
        invitate.remove(at: sender.tag)
        waitingtableView.reloadData()
    }
}

extension SearchFriendsViewController: GetUserInfoManagerDelegate, InvitedFriendsManagerDelegate {
    func managerFriendList(_ manager: InvitedFriendsManager, getFriendList friendList: [UserInfo]) {
     friendsArray = friendList
    }

    func manager(_ manager: InvitedFriendsManager, didRequests invitedList: [UserInfo]) {
        invitate.removeAll()
        invitate = invitedList
        waitingtableView.reloadData()
    }

    func manager(_ manager: InvitedFriendsManager, getPermission invitedList: [UserInfo]) {

    }

    func manager(_ manager: GetUserProfileManager, didGet userInfo: UserInfo) {
        myInfo = userInfo
    }

    func managerArray(_ manager: GetUserProfileManager, didGet userInfo: [UserInfo]) {
        allUserInfo = userInfo
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
