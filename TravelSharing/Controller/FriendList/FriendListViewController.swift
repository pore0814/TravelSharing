//
//  FriendListViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/31.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit

class FriendListViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var tabIndex: Int?

//    var invitedFriendsManager = InvitedFriendsManager()
    var myInfo: UserInfo?
    var nnn1: InvitedListViewController?
    var nnn2: SearchFriendsViewController?
    var nnn3: MyFriendListViewController?

    @IBOutlet weak var firstView: UIView!

//
    @IBOutlet weak var secondview: UIView!

    @IBOutlet weak var thirdView: UIView!

    @IBAction func indexChange(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            
            firstView.isHidden = false
            secondview.isHidden = true
            thirdView.isHidden = true

        case 1:
            firstView.isHidden = true
            secondview.isHidden = false
             thirdView.isHidden = true

        case 2:
            nnn2?.getrequestsFromMeList()

            firstView.isHidden = true
            secondview.isHidden = true
            thirdView.isHidden = false

        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "InvitedListViewController" {
            guard let nav1 = segue.destination as? InvitedListViewController else {return}
            nav1.loadViewIfNeeded()
            self.nnn1 = nav1
            
        } else if segue.identifier == "SearchFriendsViewController"{
            guard let nav2 = segue.destination as? SearchFriendsViewController else {return}
            nav2.loadViewIfNeeded()
            self.nnn2 = nav2
        } else if segue.identifier == "MyFriendListViewController"{
            guard let nav3 = segue.destination as? MyFriendListViewController else {return}
            nav3.loadViewIfNeeded()
            self.nnn3 = nav3
            
        }
    }
       
    
 

    override func viewDidLoad() {
        super.viewDidLoad()
      //setupView()
        firstView.isHidden = false
        secondview.isHidden = true
        thirdView.isHidden = true

    }

    @IBAction func addFriends(_ sender: Any) {
        print("Aaaaaaaaaddfriends")
    }
}

extension FriendListViewController: GetUserInfoManagerDelegate {

    func managerArray(_ manager: GetUserProfileManager, didGet userInfo: [UserInfo]) {}

    func manager(_ manager: GetUserProfileManager, didGet userInfo: UserInfo) {

        myInfo = userInfo
    }
}
