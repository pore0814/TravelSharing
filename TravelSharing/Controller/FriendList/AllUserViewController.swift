//
//  InviteFriendsViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/22.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit

class AllUserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let getUserInfoManager = GetUserProfileManager()

    var allUserInfo = [UserInfo]()

    var selectedIndexs = [Int]()

    var selectedCell: Bool = false

    @IBOutlet weak var allUserTableview: UITableView!

    override func viewDidLoad() {

        super.viewDidLoad()

        initUITableView()

        getUserInfoManager.delegate = self

        getUserInfoManager.getAllUserInfo()

        allUserTableview.separatorStyle  =  .none

    }
    @IBAction func backBtn(_ sender: Any) {

        dismiss(animated: true, completion: nil)

    }

    func initUITableView() {

        allUserTableview.dataSource = self

        allUserTableview.delegate = self

        let nib = UINib(nibName: "AllUsersTableViewCell", bundle: nil)

        allUserTableview.register(nib, forCellReuseIdentifier: "AllUsersTableViewCell")

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return allUserInfo.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard  let cell = allUserTableview.dequeueReusableCell(withIdentifier: "AllUsersTableViewCell")
            as? AllUsersTableViewCell else {return UITableViewCell()}

        let allUsers = allUserInfo[indexPath.row]

        cell.getCell(allUsers: allUsers)

        cell.selectionStyle = .none

        return cell
    }
}

extension AllUserViewController: GetUserInfoManagerDelegate {

    func manager(_ manager: GetUserProfileManager, didGet userInfo: UserInfo) {}

    func managerArray(_ manager: GetUserProfileManager, didGet userInfo: [UserInfo]) {

        allUserInfo = userInfo

        allUserTableview.reloadData()

    }

}
