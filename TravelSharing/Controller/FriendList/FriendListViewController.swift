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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "InvitedListViewController" {
            
            guard let invitedVC = segue.destination as? InvitedListViewController else {return}
            
            invitedVC.loadViewIfNeeded()
            
            self.invitedVC = invitedVC
            
        } else if segue.identifier == "SearchFriendsViewController"{
            
            guard let searchVC = segue.destination as? SearchFriendsViewController else {return}
            
            searchVC.loadViewIfNeeded()
            
            self.searchVC = searchVC
            
        } else if segue.identifier == "MyFriendListViewController"{
            
            guard let myFriendVC = segue.destination as? MyFriendListViewController else {return}
            
            myFriendVC.loadViewIfNeeded()
            
            self.myFreindVC = myFriendVC
            
        }
    }
       
    
 

    override func viewDidLoad() {
        
        super.viewDidLoad()

        firstView.isHidden = false
        secondview.isHidden = true
        myFriendListUIView.isHidden = true

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
