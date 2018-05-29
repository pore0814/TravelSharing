//
//  InviteFriendsViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/22.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit

class AllUserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

     let getUserInfoManager = GetUserInfoManager()
     var allUserInfo = [UserInfo]()
    var selectedIndexs = [Int]()

    @IBOutlet weak var allUserTableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        initUITableView()

        getUserInfoManager.delegate = self
        getUserInfoManager.getAllUserInfo()

        allUserTableview.allowsMultipleSelection = true

        setNavigation()
    }
    @IBAction func backBtn(_ sender: Any) {
        let detailPage = UIStoryboard(name: "Schedule", bundle: nil).instantiateViewController(withIdentifier: "ScheduleDetailViewController") as?
        ScheduleDetailViewController

        present(detailPage!, animated: true, completion: nil)
    }
    func initUITableView() {
        allUserTableview.dataSource = self
        allUserTableview.delegate = self
        let nib = UINib(nibName: "AllUsersTableViewCell", bundle: nil)
        allUserTableview.register(nib, forCellReuseIdentifier: "AllUsersTableViewCell")
    }

    func setNavigation() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUserInfo.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = allUserTableview.dequeueReusableCell(withIdentifier: "AllUsersTableViewCell") as? AllUsersTableViewCell else {return UITableViewCell()}

          let allUsers = allUserInfo[indexPath.row]
          cell.getCell(allUsers: allUsers)

        if selectedIndexs.contains(indexPath.row) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       print("----------------------------")
        if   tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            print("delete", allUserInfo[indexPath.row].uid)
        } else {
             tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
             print("add", allUserInfo[indexPath.row].uid)
        }

        //判断是否选中（选中单元格尾部打勾）

        if let index = selectedIndexs.index(of: indexPath.row) {
            selectedIndexs.remove(at: index) //原来选中的取消选中
        } else {
            selectedIndexs.append(indexPath.row) //原来没选中的就选中
        }

    }

    }

extension AllUserViewController: GetUserInfoManagerDelegate {
    func manager(_ manager: GetUserInfoManager, didGet userInfo: UserInfo) {}

    func managerArray(_ manager: GetUserInfoManager, didGet userInfo: [UserInfo]) {
        print(allUserInfo)
        allUserInfo = userInfo
        allUserTableview.reloadData()
    }
}
