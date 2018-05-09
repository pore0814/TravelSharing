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
        tableView.separatorStyle = .none
        tableView.backgroundView =  UIImageView(image: UIImage(named: "myScheduleBackground"))

        let leftNibName = UINib(nibName: "ScheduleTableViewCell", bundle: nil)
        tableView.register(leftNibName, forCellReuseIdentifier: "ScheduleTableViewCell")

        let rightNibName = UINib(nibName: "ScheuleRightTableViewCell", bundle: nil)
        tableView.register(rightNibName, forCellReuseIdentifier: "ScheuleRightTableViewCell")
        //FireBase撈資料
    //   ScheduleManager.shared.getUserInfo()
       //FireBase撈完資料會通知reloadData
       // NotificationCenter.default.addObserver(forName: .scheduleInfo, object: nil, queue: nil, using: catchNotification)
        
    
        ScheduleManager.shared.getScheduleContent()
       // ScheduleManager.shared.getScheduleContent_value()
        
         NotificationCenter.default.addObserver(self, selector: #selector(getData), name: .scheduleInfo, object: nil)
        
    }

    @objc func getData(notification:Notification){
        
        DispatchQueue.main.async {
            self.schedules = ScheduleManager.shared.scheduleDataArray
            self.tableView.reloadData()
        }

    }
//    @objc func toreloadData(notification:Notification) {
//        tableView.reloadData()
//    }

//    func catchNotification(notification: Notification) {
//        guard let userInfo = notification.userInfo,
//            let uid   = userInfo["uid"] as?  String,
//            let name  = userInfo["name"] as? String,
//            let date  = userInfo["date"] as? String,
//            let days  = userInfo["days"] as? String else {return}
//        let  schedule = ScheduleInfo(uid: uid, date: date, name: name, days: days)
//        schedules.append(schedule)
//        //按時間排序
//        //schedules.sort(by: {$0.date < $1.date})
//         print("53",schedules)
//        tableView.reloadData()
//    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedules.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableViewCell", for: indexPath) as! ScheduleTableViewCell

        let data = self.schedules[indexPath.row]
            cell.backgroundColor  = UIColor.clear
            cell.updateCell(with: data)
        
        return cell
        
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheuleRightTableViewCell", for: indexPath) as! ScheuleRightTableViewCell
//            cell.backgroundColor  = UIColor.clear
//            cell.dateLabel.text = changeDateFormate
//            cell.nameLabel.text = schedules[indexPath.row].name
//            cell.daysLabel.text = schedules[indexPath.row].days + "天"
//
//            return cell
//        }
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("79",schedules[indexPath.row].uid)
        let scheduleDetailViewController = UIStoryboard(name: "Schedule", bundle: nil).instantiateViewController(withIdentifier: "ScheduleDetailViewController") as!ScheduleDetailViewController
        self.navigationController?.pushViewController(scheduleDetailViewController, animated: true)
        
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//        let deletAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completionHandler) in
//
//          print("88", self.schedules[indexPath.row].uid)
//          //  ScheduleManager.shared.deleteSchedule(scheduleId: self.schedules[indexPath.row].uid)
//           self.schedules.remove(at: indexPath.row)
//            self.tableView.deleteRows(at: [indexPath], with: .fade)
//            print("73", [indexPath])
//            // tableView.reloadData()
//            completionHandler(true)
//
//        }
//        //編輯 Schedule
//        let editAction = UIContextualAction(style: .normal, title: "Edit") { (_, _, completionHandler) in
//            print("99","edit to next page")
//            let mainstoryboard: UIStoryboard = UIStoryboard(name: "Schedule", bundle: nil)
//            let EditViewController = mainstoryboard.instantiateViewController(withIdentifier: "AddScheduleViewController") as! AddScheduleViewController
//            self.navigationController?.pushViewController(EditViewController, animated: true)
//         EditViewController.scheduleInfoDetail = self.schedules[indexPath.row]
//
//             completionHandler(true)
//        }
//        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deletAction, editAction])
//        return swipeConfiguration
//    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editButton = UITableViewRowAction(style: .normal, title: "Edit") { (rowAction, indexpath) in
            print("\(self.schedules[indexPath.row])","edit")
           let mainstoryboard: UIStoryboard = UIStoryboard(name: "Schedule", bundle: nil)
            let EditViewController = mainstoryboard.instantiateViewController(withIdentifier: "AddScheduleViewController") as! AddScheduleViewController
              self.navigationController?.pushViewController(EditViewController, animated: true)
             EditViewController.scheduleInfoDetail = self.schedules[indexPath.row]
            
        }
        editButton.backgroundColor = UIColor.orange
    
        
        let deleteButton = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexpath) in
            print("\(self.schedules[indexPath.row])","delete")
        }
        deleteButton.backgroundColor = UIColor.red
        
        
        return[editButton,deleteButton]
    }
    
  
    

}
