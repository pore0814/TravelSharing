//
//  DistanceViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/29.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit

class DistanceViewController: UIViewController {
    
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var timeMinsLabel: UILabel!
    @IBOutlet weak var distanceKmLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.setRounded10()
        timeMinsLabel.setRounded10()
        distanceKmLabel.setRounded10()
    }


    @IBAction func reMoveBtn(_ sender: UIButton) {
    }
}
