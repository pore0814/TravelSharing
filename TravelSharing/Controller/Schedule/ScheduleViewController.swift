//
//  ScheduleTableViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/4/29.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
     var schedules = [ScheduleInfo]()
    
    @IBOutlet weak var tableView: UITableView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let leftNibName = UINib(nibName: "ScheduleTableViewCell", bundle: nil)
        tableView.register(leftNibName, forCellReuseIdentifier: "ScheduleTableViewCell")
        
        let rightNibName = UINib(nibName: "ScheuleRightTableViewCell", bundle: nil)
        tableView.register(rightNibName, forCellReuseIdentifier: "ScheuleRightTableViewCell")
        //FireBase撈資料
       ScheduleManager.shared.getUserInfo()
       //FireBase撈完資料會通知傳資料回來
        NotificationCenter.default.addObserver(forName:.scheduleInfo, object: nil, queue:nil, using: catchNotification)
    }
    
    func catchNotification(notification:Notification) -> Void{
        guard let userInfo = notification.userInfo,
            let name  = userInfo["name"] as? String,
            let date  = userInfo["date"]    as? String,
            let days  = userInfo["days"]    as? String else {return}
        let  schedule = ScheduleInfo(date: date, name: name, days: days)
        schedules.append(schedule)
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.item % 2 == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableViewCell", for: indexPath) as! ScheduleTableViewCell
                cell.date.text = schedules[indexPath.row].date
                cell.name.text = schedules[indexPath.row].name
                cell.days.text = schedules[indexPath.row].days
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheuleRightTableViewCell", for: indexPath) as! ScheuleRightTableViewCell
            return cell
        }
    }
}




