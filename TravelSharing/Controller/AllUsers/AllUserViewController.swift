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

    @IBOutlet weak var allUserTableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        initUITableView()
        
        getUserInfoManager.delegate = self
        getUserInfoManager.getAllUserInfo()
        
        setNavigation()
    }
    
    func initUITableView() {
        allUserTableview.dataSource = self
        allUserTableview.delegate = self
        let nib = UINib(nibName: "AllUsersTableViewCell", bundle: nil)
        allUserTableview.register(nib, forCellReuseIdentifier: "AllUsersTableViewCell")
    }

    func setNavigation(){
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

        return cell
    }
}
extension AllUserViewController:GetUserInfoManagerDelegate{
    func manager(_ manager: GetUserInfoManager, didGet userInfo: UserInfo) {}

    func managerArray(_ manager: GetUserInfoManager, didGet userInfo: [UserInfo]) {
        print(allUserInfo)
        allUserInfo = userInfo
        allUserTableview.reloadData()
    }
}
