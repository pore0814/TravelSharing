//
//  PrivacyViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/28.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit
import Alamofire

class PrivacyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var privacyTableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        pathdraw()
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
    
    func pathdraw() {
        // let url = "https://maps.googleapis.com/maps/api/directions/json?origin=25.034028,121.56426&destination=22.9998999,120.2268758&mode=driving"
        //25.042837, 121.564879     //25.041195, 121.565104
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=25.042837,121.564879&destination=25.058232,121.520560&mode=driving"
        
        Alamofire.request(url).responseJSON { response in
            //print(response.value)
            let result = response.value as? [String: Any]
            
            let routes = result!["routes"] as? [[String: Any]]
            let route = routes!.first
            let legs = route!["legs"] as? [[String: Any]]
            let leg = legs?.first
            let distance = leg!["distance"] as? [String: Any]
            let duration = leg!["duration"] as? [String: Any]
        }
    }
    
}
