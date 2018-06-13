//
//  MyFriendListViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/6/3.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit
import SCLAlertView

class MyFriendListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var shareScheduleManager = ShareScheduleManager()
    let invitatedFriendManager = InvitedFriendsManager()
    var friendListArray = [UserInfo]()
    var scheduleId: ScheduleInfo?
    @IBOutlet weak var lisTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        invitatedFriendManager.delegate = self
        invitatedFriendManager.myFriendList()

        let nib = UINib(nibName: "AllUsersTableViewCell", bundle: nil)
        lisTableView.register(nib, forCellReuseIdentifier: "AllUsersTableViewCell")

        lisTableView.dataSource = self
        lisTableView.delegate =  self

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendListArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = lisTableView.dequeueReusableCell(withIdentifier: "AllUsersTableViewCell") as? AllUsersTableViewCell else {return UITableViewCell()}

        cell.allUserEmailLabel.text = friendListArray[indexPath.row].email
        cell.allUserNamerLabel.text = friendListArray[indexPath.row].userName
        cell.allUsersImage.sd_setImage(with: URL(string: friendListArray[indexPath.row].photoUrl), completed: nil)
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let scheduleid = scheduleId else {return}
        var title = "確定分享行程給" + friendListArray[indexPath.row].userName

        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)

        alertView.addButton("確定") {
            self.shareScheduleManager.getMyScheduleId(scheduleId: scheduleid.uid, friendId: self.friendListArray[indexPath.row].uid)
            self.navigationController?.popViewController(animated: true)
        }
        alertView.addButton("取消") {}
        alertView.showSuccess("", subTitle: NSLocalizedString(title, comment: ""))
    }

}

extension MyFriendListViewController: InvitedFriendsManagerDelegate {

    func managerFriendList(_ manager: InvitedFriendsManager, getFriendList friendList: [UserInfo]) {
        friendListArray = friendList
        lisTableView.reloadData()
    }

    func manager(_ manager: InvitedFriendsManager, didRequests invitedList: [UserInfo]) {}

    func manager(_ manager: InvitedFriendsManager, getPermission permissionList: [UserInfo]) {}

}
