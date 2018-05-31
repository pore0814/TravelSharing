//
//  ScheduleTableViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/4/29.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit
import SVProgressHUD
import SCLAlertView

class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

     var schedules = [ScheduleInfo]()
     var userProfile: UserInfo?
     var indexNumber =  0
     var timeCount = 0
     var timer = Timer()
     var getDataFromUpdate: ScheduleInfo?
     let scheduleManager = ScheduleManager.shared
     let dateFormatter1 = TSDateFormatter1()
     let destination = DestinationManager()
     var alert = SCLAlertView()
     var indicator = true
     @IBOutlet weak var tableView: UITableView!

// display progress before loading data
    override func viewDidAppear(_ animated: Bool) {
        if indicator  == true {
        SVProgressHUD.show(withStatus: "loading")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        scheduleManager.delegate = self

        setTableView()

        setTableViewCell()

//FireBase 撈資料
        ScheduleManager.shared.getScheduleContent()

//收通知
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: .scheduleInfo, object: nil)

//Timer Stop laodingPage

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ScheduleViewController.stoplodingIcon), userInfo: nil, repeats: true)
    }

    @objc func stoplodingIcon() {
        timeCount += 1

        if  (indicator == true) && (timeCount > 5) {
            timer.invalidate()
            SVProgressHUD.dismiss()
            indicator =  false
        }

    }

    func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundView =  UIImageView(image: UIImage(named: "schedulePage-1"))
    }

//註冊tableViewCell
    func setTableViewCell() {
        let leftNibName = UINib(nibName: "ScheduleTableViewCell", bundle: nil)
        tableView.register(leftNibName, forCellReuseIdentifier: "ScheduleTableViewCell")
    }

//Notification 通知
    @objc func getData(notification: Notification) {
        DispatchQueue.main.async {
            self.schedules = ScheduleManager.shared.scheduleDataArray
            self.tableView.reloadData()
        }
            SVProgressHUD.dismiss()
            self.indicator = false
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
             } else {
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
//Edit
        let editButton = UITableViewRowAction(style: .normal, title: "Edit") { (_, _) in
            let mainstoryboard: UIStoryboard = UIStoryboard(name: "Schedule", bundle: nil)
//換頁＋傳資
            guard let editViewController = mainstoryboard.instantiateViewController(withIdentifier: "AddScheduleViewController") as? AddEditScheduleViewController else {return}
            self.navigationController?.pushViewController(editViewController, animated: true)
            editViewController.scheduleInfoDetail = self.schedules[indexPath.row]
            self.indexNumber = indexPath.row
        }
           editButton.backgroundColor = UIColor.orange
//Delete

        let deleteButton = UITableViewRowAction(style: .normal, title: "Delete") { (_, _) in
//Alert
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false)

                    let alertView = SCLAlertView(appearance: appearance)
                    alertView.addButton("確定") {
                    ScheduleManager.shared.deleteSchedule(scheduleId: self.schedules[indexPath.row].uid, arrrayIndexPath: indexPath.row)
                    self.schedules.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.reloadData()
            }
                    alertView.addButton("取消") {}
                    alertView.showSuccess("", subTitle: NSLocalizedString("是否刪除", comment: ""))
        }
            deleteButton.backgroundColor = UIColor.red
            return[editButton, deleteButton]
     }
}
extension ScheduleViewController: ScheduleManagerDelegate {
    func manager(_ manager: ScheduleManager, didGet schedule: ScheduleInfo) {
        print("107", schedule)
        schedules[indexNumber] = schedule
        schedules.sort(by: {$0.date < $1.date})
        tableView.reloadData()
    }
}
