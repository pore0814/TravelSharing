//
//  ScheduleTableViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/4/29.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

     var schedules = [ScheduleInfo]()

    @IBOutlet weak var tableView: UITableView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

    }

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
       //FireBase撈完資料會通知reloadData
        NotificationCenter.default.addObserver(forName: .scheduleInfo, object: nil, queue: nil, using: catchNotification)
    }

//    @objc func toreloadData(notification:Notification) {
//        tableView.reloadData()
//    }

    func catchNotification(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let uid   = userInfo["uid"] as?  String,
            let name  = userInfo["name"] as? String,
            let date  = userInfo["date"] as? String,
            let days  = userInfo["days"] as? String else {return}
        let  schedule = ScheduleInfo(uid: uid, date: date, name: name, days: days)
        schedules.append(schedule)
        print(schedules)
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedules.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.item % 2 == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableViewCell", for: indexPath) as! ScheduleTableViewCell

                cell.dateLabel.text = schedules[indexPath.row].date
                cell.nameLabel.text = schedules[indexPath.row].name
                cell.daysLabel.text = schedules[indexPath.row].days
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheuleRightTableViewCell", for: indexPath) as! ScheuleRightTableViewCell

            cell.dateLabel.text = schedules[indexPath.row].date
            cell.nameLabel.text = schedules[indexPath.row].name
            cell.daysLabel.text = schedules[indexPath.row].days

            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let scheduleDetailViewController = UIStoryboard(name: "Schedule", bundle: nil).instantiateViewController(withIdentifier: "ScheduleDetailViewController") as!ScheduleDetailViewController
        self.navigationController?.pushViewController(scheduleDetailViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deletAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completionHandler) in

          print("88", self.schedules[indexPath.row].uid)
            ScheduleManager.shared.deleteSchedule(scheduleId: self.schedules[indexPath.row].uid)
           self.schedules.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            print("73", [indexPath])
            // tableView.reloadData()
            completionHandler(true)

        }
        //編輯 Schedule
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (_, _, completionHandler) in
            let mainstoryboard: UIStoryboard = UIStoryboard(name: "Schedule", bundle: nil)

            let newViewController = mainstoryboard.instantiateViewController(withIdentifier: "ScheduleDetailViewController") as! ScheduleDetailViewController
            self.present(newViewController, animated: true, completion: nil)

          //  vc.scheduleInfoDetail = self.schedules[indexPath.row]

             completionHandler(true)
        }
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deletAction, editAction])
        return swipeConfiguration
    }

//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let editButton = UITableViewRowAction(style: .normal, title: "Edit") { (rowAction, indexpath) in
//            print("\(self.schedules[indexPath.row])")
//        }
//        editButton.backgroundColor = UIColor.yellow
//        return[editButton]
//    }

}
