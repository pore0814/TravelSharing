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

    var myInfo: UserInfo?

    var invitedVC: InvitedListViewController?

    var searchVC: SearchFriendsViewController?

    var myFreindVC: MyFriendListViewController?

    @IBOutlet weak var firstView: UIView!

//
    @IBOutlet weak var secondview: UIView!

    @IBOutlet weak var myFriendListUIView: UIView!

    @IBAction func indexChange(_ sender: UISegmentedControl) {

        switch segmentedControl.selectedSegmentIndex {

        case 0:

            firstView.isHidden = false
            secondview.isHidden = true
            myFriendListUIView.isHidden = true

        case 1:

             firstView.isHidden = true
             secondview.isHidden = false
             myFriendListUIView.isHidden = true

        case 2:

            searchVC?.getrequestsFromMeList()
            firstView.isHidden = true
            secondview.isHidden = true
            myFriendListUIView.isHidden = false

        default:

            break

        }
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        firstView.isHidden = false

        secondview.isHidden = true

        myFriendListUIView.isHidden = true

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "InvitedListViewController" {

            guard let invitedvc = segue.destination as? InvitedListViewController else {return}

            invitedvc.loadViewIfNeeded()

            self.invitedVC = invitedvc

        } else if segue.identifier == "SearchFriendsViewController"{

            guard let searchvc = segue.destination as? SearchFriendsViewController else {return}

            searchvc.loadViewIfNeeded()

            self.searchVC = searchvc

        } else if segue.identifier == "MyFriendListViewController"{

            guard let myFriendvc = segue.destination as? MyFriendListViewController else {return}

            myFriendvc.loadViewIfNeeded()

            self.myFreindVC = myFriendvc

        }
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
