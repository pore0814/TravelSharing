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

class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PlayVideoCellProtocol {
    
    func playVideoButtonDidSelect(_ cell: ScheduleTableViewCell, row: Int) {
        
    }
    
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
    var backgroundArray = ["view", "logoPage1", "schedulePage-1", "schedulePage-2", "schedulePage-1"]
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidAppear(_ animated: Bool) {
        
        if indicator  == true {
            
            SVProgressHUD.show(withStatus: "loading")
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

       ScheduleManager.shared.getScheduleContent()
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scheduleManager.delegate = self
        
        setTableView()
        
        setTableViewCell()

        //收通知
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: .scheduleInfo, object: nil)
        
        //Timer Stop laodingPage
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ScheduleViewController.stoplodingIcon), userInfo: nil, repeats: true)
        
          firstLogin()
    }
    
        func firstLogin(){
            
         var firstLogin = UserDefaults.standard.object(forKey: "firstLogin") as? Bool
            
            if firstLogin == nil {
                
                AlertManager.showEdit(title: "按右上角新增旅程", subTitle: "")
                
                UserDefaults.standard.set(true, forKey: "firstLogin")
                
                UserDefaults.standard.synchronize()
                
            }
      }
    
    @objc func stoplodingIcon() {
        
        timeCount += 1
        
        if  (indicator == true) && (timeCount > 3) {
            
            timer.invalidate()
            
            SVProgressHUD.dismiss()
            
            indicator =  false
            
        }
    }
    
    func setTableView() {
        
        tableView.dataSource = self
        
        tableView.delegate = self
        
        tableView.separatorStyle = .none
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
        
        let  index = indexPath.row % 5
        
        if  let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableViewCell", for: indexPath)
            
            as? ScheduleTableViewCell {
            
            let data = self.schedules[indexPath.row]
            
            cell.backgroundColor  = UIColor.clear
            
            cell.updateCell(with: data)
            
            cell.leftImageView.image = UIImage(named: backgroundArray[index])
            
            cell.selectionStyle = .none
            
            cell.delegate = self
            
            cell.coEditedBtn.tag = indexPath.row
            
          
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
            
            self.indexNumber = indexPath.row
            
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
            
            Alertmanager1.shared.showCheck(with: "是否刪除", message: "", delete: {
                
                ScheduleManager.shared.deleteSchedule(scheduleId: self.schedules[indexPath.row].uid, arrrayIndexPath: indexPath.row)
                
                self.schedules.remove(at: indexPath.row)
                
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                
                tableView.reloadData()
                
            }, cancel: {
                
                print("取消")
                
            })
        }
           deleteButton.backgroundColor = UIColor.red
        //分享
        let shareButton = UITableViewRowAction(style: .normal, title: "Shard") { (_, _) in
            
            guard let friendListVc = UIStoryboard(name: "FriendsList", bundle: nil)
                
                .instantiateViewController(withIdentifier: "MyFriendListViewController") as? MyFriendListViewController else {return}
            
            friendListVc.scheduleId = self.schedules[indexPath.row]
            
            self.navigationController?.pushViewController(friendListVc, animated: true)
        }
            shareButton.backgroundColor = UIColor.brown
        
            return[editButton, deleteButton, shareButton]
    }
}
extension ScheduleViewController: ScheduleManagerDelegate {
    
    func manager(_ manager: ScheduleManager, didGet schedule: ScheduleInfo) {
        
        schedules[indexNumber] = schedule
        
        schedules.sort(by: {$0.date < $1.date})
        
        tableView.reloadData()
        
    }
}
