//
//  InvitedListViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/6/3.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit

class InvitedListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    var invitedFriendsManager = InvitedFriendsManager()
    var invitedListArray = [WaitingList]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        invitedFriendsManager.delegate =  self
        invitedFriendsManager.requestsWaitForPermission()
        
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "AllUsersTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "AllUsersTableViewCell")
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AllUsersTableViewCell") as? AllUsersTableViewCell else {return UITableViewCell()}
        cell.allUserEmailLabel.text = invitedListArray[indexPath.row].email
        cell.allUserNamerLabel.text = invitedListArray[indexPath.row].userName
        cell.allUsersImage.sd_setImage(with: URL(string: invitedListArray[indexPath.row].photoUrl), completed: nil)
        cell.addFriendBtn.isHidden = false
        cell.cancelFriendInvitedBtn.isHidden =  false
        cell.addFriendBtn.addTarget(self, action: #selector(permitted(sender:)), for: .touchUpInside)
        cell.cancelFriendInvitedBtn.addTarget(self, action:#selector(canceled(sender:)), for: .touchUpInside)
        return cell
    }
    
   @objc func  permitted(sender:UIButton){
    print("permitted")
        
    }
    
    @objc func canceled(sender:UIButton){
        invitedFriendsManager.cancelPermission(friendID: invitedListArray[sender.tag].uid)
        invitedFriendsManager.cancelRequestFromMe(friendID: invitedListArray[sender.tag].uid)
        print("cancel")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invitedListArray.count
    }
    
    

}

extension InvitedListViewController:InvitedFriendsManagerDelegate{
    func manager(_ manager: InvitedFriendsManager, didGet invitedList: [WaitingList]) {
        
    }
    
    func manager(_ manager: InvitedFriendsManager, getPermission permissionList: [WaitingList]) {
        invitedListArray = permissionList
        tableView.reloadData()
    }
    
   
}
