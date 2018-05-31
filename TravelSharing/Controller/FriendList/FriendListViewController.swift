//
//  FriendListViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/31.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit

class FriendListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func addFriends(_ sender: Any) {
        print("Aaaaaaaaaddfriends")
        
            guard let allUserVC = UIStoryboard(name: "FriendsList", bundle: nil).instantiateInitialViewController as? AllUserViewController else {return}
            self.navigationController?.pushViewController(allUserVC, animated: true)
        
        
//        if let scheduleDetailViewController = UIStoryboard(name: "Schedule", bundle: nil)
//            .instantiateViewController(withIdentifier: "ScheduleDetailViewController")
//            as? ScheduleDetailViewController {
//            let data = self.schedules[indexPath.row]
//            scheduleDetailViewController.schedulDetail = data
//            self.navigationController?.pushViewController(scheduleDetailViewController, animated: true)
        
        
     
    }
    

}
