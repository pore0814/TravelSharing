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

    @IBOutlet weak var listTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        invitatedFriendManager.delegate = self

        invitatedFriendManager.myFriendList()

        configureTableView()

    }

    func configureTableView() {

        let nib = UINib(nibName: "AllUsersTableViewCell", bundle: nil)

        listTableView.register(nib, forCellReuseIdentifier: "AllUsersTableViewCell")

        listTableView.dataSource = self

        listTableView.delegate =  self

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return friendListArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = listTableView.dequeueReusableCell(withIdentifier: "AllUsersTableViewCell") as? AllUsersTableViewCell else {return UITableViewCell()}

        cell.allUserEmailLabel.text = friendListArray[indexPath.row].email

        cell.allUserNamerLabel.text = friendListArray[indexPath.row].userName

        cell.allUsersImage.sd_setImage(with: URL(string: friendListArray[indexPath.row].photoUrl), completed: nil)

        cell.selectionStyle = .none

        return cell

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let scheduleid = scheduleId else {return}

        var title = "確定分享行程給" + friendListArray[indexPath.row].userName

        Alertmanager1.shared.showCheck(with: title, message: "", delete: {

            self.shareScheduleManager.getMyScheduleId(scheduleId: scheduleid.uid, friendId: self.friendListArray[indexPath.row].uid)

            self.navigationController?.popViewController(animated: true)

        }) {

        }
    }

}

extension MyFriendListViewController: InvitedFriendsManagerDelegate {

    func managerFriendList(_ manager: InvitedFriendsManager, getFriendList friendList: [UserInfo]) {

        friendListArray = friendList
        listTableView.reloadData()
    }

    func manager(_ manager: InvitedFriendsManager, didRequests invitedList: [UserInfo]) {}

    func manager(_ manager: InvitedFriendsManager, getPermission permissionList: [UserInfo]) {}

}
