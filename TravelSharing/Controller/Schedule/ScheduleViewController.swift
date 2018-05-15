//
//  ScheduleTableViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/4/29.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

     var schedules = [ScheduleInfo]()
//     var dateInfoArray = [DateInfo]()
     var indexNumber =  0
     var getDataFromUpdate : ScheduleInfo?
     let scheduleManager = ScheduleManager.shared
     let dateFormatter = TSDateFormatter()
      let dateFormatter1 = TSDateFormatter1()
    
     let destination = DestinationManager()

    @IBOutlet weak var tableView: UITableView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scheduleManager.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundView =  UIImageView(image: UIImage(named: "schedulePage"))

        let leftNibName = UINib(nibName: "ScheduleTableViewCell", bundle: nil)
        tableView.register(leftNibName, forCellReuseIdentifier: "ScheduleTableViewCell")

        let rightNibName = UINib(nibName: "ScheuleRightTableViewCell", bundle: nil)
        tableView.register(rightNibName, forCellReuseIdentifier: "ScheuleRightTableViewCell")

        ScheduleManager.shared.getScheduleContent()
        
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: .scheduleInfo, object: nil)
        
         print("=======")
        let date = "2018 05 22"
        let dateformat = DateFormatter()
        dateformat.dateFormat = "MM/dd"
        print(date)
      
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
                cell.selectionStyle = .none
        
        return cell
  
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let scheduleDetailViewController = UIStoryboard(name: "Schedule",bundle: nil)
                    .instantiateViewController(withIdentifier: "ScheduleDetailViewController")
                     as! ScheduleDetailViewController

        let data = self.schedules[indexPath.row]
        scheduleDetailViewController.schedulDetail = data
//        dateInfoArray.removeAll()
    
     //   scheduleDetailViewController.getDateInfo = dateFormatter.getTSDate(indexNumer: data)
        self.navigationController?.pushViewController(scheduleDetailViewController, animated: true)
        
    }
    
   //Edit and Delete
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editButton = UITableViewRowAction(style: .normal, title: "Edit") { (rowAction, indexpath) in
            let mainstoryboard: UIStoryboard = UIStoryboard(name: "Schedule", bundle: nil)
            let EditViewController = mainstoryboard.instantiateViewController(withIdentifier: "AddScheduleViewController") as! AddEditScheduleViewController

            self.navigationController?.pushViewController(EditViewController, animated: true)
            EditViewController.scheduleInfoDetail = self.schedules[indexPath.row]
            self.indexNumber = indexPath.row
        }
           editButton.backgroundColor = UIColor.orange
        
        let deleteButton = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexpath) in
            ScheduleManager.shared.deleteSchedule(scheduleId: self.schedules[indexPath.row].uid)
            self.schedules.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
            deleteButton.backgroundColor = UIColor.red
            return[editButton,deleteButton]
     }
}

extension ScheduleViewController : ScheduleManagerDelegate {
    func manager(_ manager: ScheduleManager, didGet schedule: ScheduleInfo) {
        print(schedule)
        schedules[indexNumber] = schedule
        schedules.sort(by: {$0.date < $1.date})
        tableView.reloadData()
    }
}


