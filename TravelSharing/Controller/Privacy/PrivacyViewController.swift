//
//  PrivacyViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/28.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit

class PrivacyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var privacyTableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = privacyTableview.dequeueReusableCell(withIdentifier: "Cell")
        return cell!
    }

    @IBAction func backBtn(_ sender: Any) {
  dismiss(animated: true, completion: nil)
    }
}
