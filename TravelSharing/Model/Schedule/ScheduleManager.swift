//
//  Schedule.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/2.
//  Copyright © 2018年 Annie. All rights reserved.
//

import FirebaseDatabase

protocol ScheduleManagerDelegate: class {
    func manager(_ manager: ScheduleManager, didGet schedule: ScheduleInfo)
}

class ScheduleManager {
   static let shared = ScheduleManager()

    weak var delegate: ScheduleManagerDelegate?
    var scheduleDataInfo: ScheduleInfo?
    var scheduleDataArray = [ScheduleInfo]()
    var destinagionManager = DestinationManager()

//    func firstScheduleExample(firstScheduleId: String, userId: String) {
//
//        let  scheduleUid = FireBaseConnect.databaseRef.childByAutoId().key
//        let  scheduleInfo = ["uid": firstScheduleId, "name": "範例",
//                             "date": "2019 01 01", "days": "2", "host": userId]
//        FireBaseConnect.databaseRef
//            .child(Constants.FireBaseSchedules)
//            .child(scheduleUid)
//            .setValue(scheduleInfo)
//
//    }

//新增Schedule資料
    func saveScheduleInfo(scheduleName: String, scheudleDate: String, scheduleDay: String) {
        //User Id
        guard let userid = UserManager.shared.getFireBaseUID() else {return}
              let  scheduleUid = FireBaseConnect.databaseRef.childByAutoId().key
              let  scheduleInfo = ["uid": scheduleUid, "name": scheduleName,
                                  "date": scheudleDate, "days": scheduleDay, "host": userid]
              FireBaseConnect.databaseRef
                    .child(Constants.FireBaseSchedules)
                    .child(scheduleUid)
                    .setValue(scheduleInfo)
        }

//刪除(同時刪除Schedule下的uid 和User下Schedule的uid)
    func deleteSchedule(scheduleId: String, arrrayIndexPath: Int) {
        guard let userid = UserManager.shared.getFireBaseUID() else {return}
        /* 先刪除Schedule_id */ FireBaseConnect.databaseRef.child(Constants.FireBaseSchedules).child(scheduleId).removeValue { error, _ in
                   self.scheduleDataArray.remove(at: arrrayIndexPath)
                   if error != nil {
                        AlertManager.showEdit(title: Constants.WrongMessage, subTitle: Constants.FailToDelete)
                    }
                }
            }

    //修改
    func updateaveScheduleInfo(scheduleUid: String?, scheduleName: String, scheudleDate: String, scheduleDay: String) {
        guard let userid = UserManager.shared.getFireBaseUID(), let scheduleUUid = scheduleUid else {return}
        let  updateScheduleInfo = ["uid": scheduleUid, "name": scheduleName,
                                   "date": scheudleDate, "days": scheduleDay, "host": userid]
        FireBaseConnect.databaseRef
            .child(Constants.FireBaseSchedules)
            .child(scheduleUUid)
            .updateChildValues(updateScheduleInfo)

        let data =  ScheduleInfo(uid: scheduleUid!, date: scheudleDate, name: scheduleName, days: scheduleDay)

        DispatchQueue.main.async {
            self.delegate?.manager(self, didGet: data)
            print(self.delegate)
        }
    }

// 到FireBase  撈schedules資料
    func getScheduleContent() {
        
        guard let userid = UserManager.shared.getFireBaseUID() else {return}
        
        scheduleDataArray.removeAll()
        
        FireBaseConnect
            .databaseRef
            .child(Constants.FireBaseSchedules)
            .queryOrdered(byChild: "host")
            .queryEqual(toValue: userid)
            .observeSingleEvent(of: .value) { (snapshot) in
                
                guard let values = snapshot.value as? [String: [String: Any]] else { return }
                for value in values.values {
                    guard let uid = value["uid"] as? String ,
                        let name  = value["name"] as? String ,
                        let date  = value["date"] as? String ,
                        let days  = value["days"] as? String else {return}
                    let schedule = ScheduleInfo(uid: uid, date: date, name: name, days: days)
                    self.scheduleDataArray.append(schedule)
                }
                
                self.scheduleDataArray.sort(by: {$0.date > $1.date})
                
                NotificationCenter.default.post(
                    name: .scheduleInfo,
                    object: nil)
        }
    }
}
