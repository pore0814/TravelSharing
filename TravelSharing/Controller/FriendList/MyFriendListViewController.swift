//
//  MyFriendListViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/6/3.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit

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

//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
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

        print(friendListArray[indexPath.row].uid)
            shareScheduleManager.getMyScheduleId(scheduleId: scheduleid.uid, friendId: friendListArray[indexPath.row].uid)
        navigationController?.popViewController(animated: true)

    }
}

extension MyFriendListViewController: InvitedFriendsManagerDelegate {

    func managerFriendList(_ manager: InvitedFriendsManager, getPermission friendList: [UserInfo]) {
        friendListArray = friendList
        lisTableView.reloadData()
    }

    func manager(_ manager: InvitedFriendsManager, didGet invitedList: [UserInfo]) {}

    func manager(_ manager: InvitedFriendsManager, getPermission permissionList: [UserInfo]) {}

}
