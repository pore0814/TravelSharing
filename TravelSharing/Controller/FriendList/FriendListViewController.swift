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
            firstView.isHidden = true
            secondview.isHidden = true
            thirdView.isHidden = false

        default:
            break
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
      //setupView()
        firstView.isHidden = false
        secondview.isHidden = true
        thirdView.isHidden = true

    }

    // MARK: - View Methods
    private func setupView() {
     //  setupSegmentedController()
       // updateview()
     }

//    private func updateview(){
//        firstChildTabVC?.view.isHidden = !(segmentedControl.selectedSegmentIndex == 0)
//        secondChildTabVC?.view.isHidden = (segmentedControl.selectedSegmentIndex == 0)
//
//    }

//    private func setupSegmentedController(){
//        segmentedControl.removeAllSegments()
//        segmentedControl.insertSegment(withTitle: "aaa", at: 0, animated: false)
//       segmentedControl.insertSegment(withTitle: "bbb", at: 1, animated: false)
//        segmentedControl.addTarget(self, action: #selector(selectionDidChange(sender:)), for: .valueChanged)
//        segmentedControl.selectedSegmentIndex = 0
//    }
//
//    //Mark: Sctions
//    @objc func selectionDidChange(sender:UISegmentedControl){
//        updateview()
//    }
//
//override func addChildViewController(_ childController: UIViewController) {
//
//
//
//        addChildViewController(childController)
//        view.addSubview(childController.view)
//
//        childController.view.frame = view.bounds
//        childController.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
//        childController.didMove(toParentViewController: self)
//
//    }

    @IBAction func addFriends(_ sender: Any) {
        print("Aaaaaaaaaddfriends")
//        
//            guard let allUserVC = UIStoryboard(name: "FriendsList", bundle: nil).instantiateInitialViewController as? SearchFriendsViewController else {return}
//            self.navigationController?.pushViewController(allUserVC, animated: true)
//        guard let allUserVC = UIStoryboard(name: "FriendsList", bundle: nil).instantiateInitialViewController as? InvitedListViewController else {return}
//                self.navigationController?.pushViewController(allUserVC, animated: true)
    }
}

extension FriendListViewController: GetUserInfoManagerDelegate {
    func managerArray(_ manager: GetUserProfileManager, didGet userInfo: [UserInfo]) {}

    func manager(_ manager: GetUserProfileManager, didGet userInfo: UserInfo) {
       myInfo = userInfo
        }
    }
