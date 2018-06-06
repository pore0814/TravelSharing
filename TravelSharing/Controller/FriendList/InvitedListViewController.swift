//
//  InvitedListViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/6/3.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit
import SVProgressHUD

class InvitedListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var invitedFriendsManager = InvitedFriendsManager()
    var getUserInfoManager = GetUserProfileManager()
    var invitedListArray = [UserInfo]()
    var myInfo: UserInfo?

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setDelegateAndCallFunction()

        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "AllUsersTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "AllUsersTableViewCell")

    }

    func setDelegateAndCallFunction() {
        invitedFriendsManager.delegate =  self
        invitedFriendsManager.requestsWaitForPermission()

        getUserInfoManager.delegate = self
        getUserInfoManager.getMyInfo()

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AllUsersTableViewCell") as? AllUsersTableViewCell else {return UITableViewCell()}
        cell.allUserEmailLabel.text = invitedListArray[indexPath.row].email
        cell.allUserNamerLabel.text = invitedListArray[indexPath.row].userName
        cell.allUsersImage.sd_setImage(with: URL(string: invitedListArray[indexPath.row].photoUrl), completed: nil)
        cell.addFriendBtn.isHidden = false
        cell.cancelFriendInvitedBtn.isHidden =  false
        cell.addFriendBtn.addTarget(self, action: #selector(permitted(sender:)), for: .touchUpInside)
        cell.cancelFriendInvitedBtn.addTarget(self, action: #selector(canceled(sender:)), for: .touchUpInside)
        return cell
    }

   @objc func  permitted(sender: UIButton) {
    guard let myinfo = myInfo else {return}
    if invitedListArray.count > 0 {
       SVProgressHUD.show(withStatus: "delete")
      invitedFriendsManager.beFriend(myInfo: myinfo, friendInfo: invitedListArray[sender.tag])
      invitedFriendsManager.deletePermission(friendID: invitedListArray[sender.tag].uid)
      invitedFriendsManager.deletRequetFromMe(friendID: invitedListArray[sender.tag].uid)
      invitedListArray.remove(at: sender.tag)
     tableView.reloadData()
    }else {
        AlertManager.showError(title: Constants.NoData, subTitle: "")
    }
    print("permitted")
    SVProgressHUD.dismiss()
    }

    @objc func canceled(sender: UIButton) {
        if  invitedListArray.count > 0 {
        invitedFriendsManager.cancelPermission(friendID: invitedListArray[sender.tag].uid)
        invitedFriendsManager.cancelRequestFromMe(friendID: invitedListArray[sender.tag].uid)
        invitedFriendsManager.deletePermission(friendID: invitedListArray[sender.tag].uid)
        invitedFriendsManager.deletRequetFromMe(friendID: invitedListArray[sender.tag].uid)
        invitedListArray.remove(at: sender.tag)
        tableView.reloadData()
        }
        print("cancel")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invitedListArray.count
    }

}

extension InvitedListViewController: InvitedFriendsManagerDelegate, GetUserInfoManagerDelegate {
    func managerFriendList(_ manager: InvitedFriendsManager, getFriendList friendList: [UserInfo]) {}

    func manager(_ manager: GetUserProfileManager, didGet userInfo: UserInfo) {
        myInfo = userInfo
    }
    func managerArray(_ manager: GetUserProfileManager, didGet userInfo: [UserInfo]) {}

    func manager(_ manager: InvitedFriendsManager, didRequests invitedList: [UserInfo]) {}

    func manager(_ manager: InvitedFriendsManager, getPermission permissionList: [UserInfo]) {
        invitedListArray = permissionList
        tableView.reloadData()
    }
}
