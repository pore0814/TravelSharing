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
    var getUserInfoManager = GetUserProfileManager()
    var invitedFriendManager = InvitedFriendsManager()

    var searchController = UISearchController()
    var friendInfo: UserInfo?
    var myInfo: UserInfo?
    var invitate = [UserInfo]()

    @IBOutlet weak var addFriendsBtn: UIButton!

    @IBOutlet weak var waitingtableView: UITableView!

    @IBOutlet weak var friendProfileImg: UIImageView!
    @IBOutlet weak var friendUserNamerLabel: UILabel!
    @IBOutlet weak var friendEmailLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        initModelManager()
        
        initSearchBar()

        initTableView()
        
        addFriendsBtn.setRounded10()
    }
    
    func initModelManager(){
        getUserInfoManager.delegate = self
        getUserInfoManager.getAllUserInfo()
        getUserInfoManager.getMyInfo()
        
        invitedFriendManager.delegate = self
        invitedFriendManager.requestsFromMeList()
    }
    
    func initSearchBar(){
        friendSearchBar.delegate = self
        friendSearchBar.returnKeyType  = UIReturnKeyType.done
    }
    
    func initTableView(){
        waitingtableView.dataSource = self
        waitingtableView.delegate = self
        
        let nib  = UINib(nibName: "AllUsersTableViewCell", bundle: nil)
        waitingtableView.register(nib, forCellReuseIdentifier: "AllUsersTableViewCell")
    }

//加朋友
    @IBAction func addFriends(_ sender: Any) {
        guard let friendinfomation = friendInfo else {return}

                guard let myinfo = myInfo else {return}
                invitedFriendManager.sendRequestToFriend(myinfo, sendRtoF: friendinfomation)
                invitedFriendManager.waitingPermission(myinfo, sendRtoF: friendinfomation)
                addFriendsBtn.isHidden = true
                friendEmailLabel.text = ""
                friendUserNamerLabel.text = ""
                friendProfileImg.isHidden =  true

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
    

     func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var friendEmail = friendSearchBar.text
        friendSearchBar.enablesReturnKeyAutomatically = true
        friendSearchBar.resignFirstResponder()
        friendSearchBar.showsCancelButton = true
        
                for index in 0...allUserInfo.count - 1 {
                    if friendEmail! == allUserInfo[index].email {
                        friendEmailLabel.text = allUserInfo[index].email
                        friendUserNamerLabel.text = allUserInfo[index].userName
                        friendProfileImg.sd_setImage(with: URL(string: allUserInfo[index].photoUrl), completed: nil)
                         friendInfo =  allUserInfo[index]
                         addFriendsBtn.isHidden = false
                        
                        searchBar.text = ""
                       return

                    } else {
                        friendEmailLabel.text = "無資料"
                    }
                }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("invitate.count-----------")
        print(invitate.count)
        return invitate.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AllUsersTableViewCell") as? AllUsersTableViewCell else {return UITableViewCell()}

        cell.allUserEmailLabel.text = invitate[indexPath.row].email
        cell.allUserNamerLabel.text = invitate[indexPath.row].userName
        cell.allUsersImage.sd_setImage(with: URL(string: invitate[indexPath.row].photoUrl), completed: nil)
        cell.addFriendBtn.setTitle("取消", for: .normal)
//        cell.addFriendBtn.isHidden = false
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
        print("abc")
    }

}
extension SearchFriendsViewController: GetUserInfoManagerDelegate, InvitedFriendsManagerDelegate {
    func managerFriendList(_ manager: InvitedFriendsManager, getFriendList friendList: [UserInfo]) {}

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