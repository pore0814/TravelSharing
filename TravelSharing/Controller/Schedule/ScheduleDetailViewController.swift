//
//  ScheduleDetailViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/5.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit

class ScheduleDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let addBarButtonItem = UIBarButtonItem.init(title: "Add", style: .done, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = addBarButtonItem
    }

    @objc func addTapped(sender: AnyObject) {
        print("hjxdbsdhjbv")
        let scheduleDetailToAddLocation = UIStoryboard(name: "Schedule", bundle: nil).instantiateViewController(withIdentifier: "AddLocationViewController") as!
        AddLocationViewController

        self.navigationController?.pushViewController(scheduleDetailToAddLocation, animated: true)
    }

}
