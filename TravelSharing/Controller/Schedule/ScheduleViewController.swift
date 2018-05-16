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
     var indexNumber =  0
     var getDataFromUpdate: ScheduleInfo?
     let scheduleManager = ScheduleManager.shared
     let dateFormatter1 = TSDateFormatter1()
     let destination = DestinationManager()
     @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        scheduleManager.delegate = self

        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundView =  UIImageView(image: UIImage(named: "schedulePage"))
     //註冊tableViewCell
        let leftNibName = UINib(nibName: "ScheduleTableViewCell", bundle: nil)
        tableView.register(leftNibName, forCellReuseIdentifier: "ScheduleTableViewCell")
    //撈Schedule資料
        ScheduleManager.shared.getScheduleContent()
    //收通知
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: .scheduleInfo, object: nil)
      }

    @objc func getData(notification: Notification) {
        DispatchQueue.main.async {
            self.schedules = ScheduleManager.shared.scheduleDataArray
            self.tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedules.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableViewCell", for: indexPath) as? ScheduleTableViewCell {
                let data = self.schedules[indexPath.row]
                cell.backgroundColor  = UIColor.clear
                cell.updateCell(with: data)
                cell.selectionStyle = .none
                return cell
        }else{
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       if let scheduleDetailViewController = UIStoryboard(name: "Schedule", bundle: nil)
                    .instantiateViewController(withIdentifier: "ScheduleDetailViewController")
                    as? ScheduleDetailViewController {
          let data = self.schedules[indexPath.row]
        scheduleDetailViewController.schedulDetail = data
        self.navigationController?.pushViewController(scheduleDetailViewController, animated: true)
        }
    }
   //Edit and Delete
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editButton = UITableViewRowAction(style: .normal, title: "Edit") { (_, _) in
            let mainstoryboard: UIStoryboard = UIStoryboard(name: "Schedule", bundle: nil)
            //換頁＋傳資
            guard let editViewController = mainstoryboard.instantiateViewController(withIdentifier: "AddScheduleViewController") as? AddEditScheduleViewController else {return}
            self.navigationController?.pushViewController(editViewController, animated: true)
            editViewController.scheduleInfoDetail = self.schedules[indexPath.row]
            self.indexNumber = indexPath.row
        }
           editButton.backgroundColor = UIColor.orange

        let deleteButton = UITableViewRowAction(style: .normal, title: "Delete") { (_, _) in
            ScheduleManager.shared.deleteSchedule(scheduleId: self.schedules[indexPath.row].uid)
            self.schedules.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
            deleteButton.backgroundColor = UIColor.red
            return[editButton, deleteButton]
     }
}

extension ScheduleViewController: ScheduleManagerDelegate {
    func manager(_ manager: ScheduleManager, didGet schedule: ScheduleInfo) {
        print(schedule)
        schedules[indexNumber] = schedule
        schedules.sort(by: {$0.date < $1.date})
        tableView.reloadData()
    }
}
