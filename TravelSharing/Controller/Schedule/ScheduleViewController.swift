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
     var indexNumber =  0
    var getDataFromUpdate : ScheduleInfo?
    
    let scheduleManager = ScheduleManager.shared
    
    

    @IBOutlet weak var tableView: UITableView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(red: 248.0/255.0, green: 187.0/255.0, blue: 208.0/255.0, alpha: 1 )
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        scheduleManager.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundView =  UIImageView(image: UIImage(named: "schedulePage"))
        

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
    
    func getDate(indexNumber: ScheduleInfo){
        let dateformate = DateFormatter()
            dateformate.dateFormat = "yyyy.MM.dd"
        

        print(indexNumber.date)
        
        guard let startdate = dateformate.date(from:indexNumber.date) else {return}
        print(startdate)
        print(indexNumber.days)
        guard let day = Int(indexNumber.days) else {return}
      
        for i in 0...day {
        let enddate = Calendar.current.date(byAdding:.day , value:i , to: startdate)
       let a =  dateformate.string(from: enddate!)
       let weekday = Calendar.current.component(.weekday, from: enddate!)
        dateformate.dateFormat = "MM.dd"
            print(a)
         dateformate.dateFormat = "EE"
        print(weekday)
            
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let scheduleDetailViewController = UIStoryboard(name: "Schedule", bundle: nil).instantiateViewController(withIdentifier: "ScheduleDetailViewController") as!ScheduleDetailViewController
        let data = self.schedules[indexPath.row]
        getDate(indexNumber: data)
        
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
