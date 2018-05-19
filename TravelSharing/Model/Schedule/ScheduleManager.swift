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

    //新增Schedule資料
    func saveScheduleInfo(uid: String?, scheduleName: String, scheudleDate: String, scheduleDay: String) {
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
    func deleteSchedule(scheduleId: String) {
        guard let userid = UserManager.shared.getFireBaseUID() else {return}
        /* 先刪除Schedule_id */ FireBaseConnect.databaseRef.child(Constants.FireBaseSchedules).child(scheduleId).removeValue { error, _ in
            /* 再刪除使用者Schedule下的Schedule_id  */
            if error == nil {
                FireBaseConnect.databaseRef.child(Constants.FireBaseUsers).child(userid).child(Constants.FireBaseSchedule).child(scheduleId).removeValue { error, _ in
                    if error != nil {
                        AlertToUser().alert.showEdit(Constants.WrongMessage, subTitle: "刪除失敗")
                    }
                }
            }
        }
    }

    //修改
    func updateaveScheduleInfo(scheduleUid: String?, scheduleName: String, scheudleDate: String, scheduleDay: String) {
         guard let userid = UserManager.shared.getFireBaseUID(),let scheduleUUid = scheduleUid else {return}
         let  updateScheduleInfo = ["uid": scheduleUid, "name": scheduleName,
                                    "date": scheudleDate, "days": scheduleDay, "host": userid]
        FireBaseConnect.databaseRef
            .child(Constants.FireBaseSchedules)
            .child(scheduleUUid)
            .setValue(updateScheduleInfo)

        let data =  ScheduleInfo(uid: scheduleUid!, date: scheudleDate, name: scheduleName, days: scheduleDay)

        DispatchQueue.main.async {
            self.delegate?.manager(self, didGet: data)
            print(self.delegate)
        }
    }

/*取users裡將使用者的schedule_id放到Array裡，再到Schedules裡將這些uid的內容撈出來
    func getUserInfo() {
        var ScheduleUidArray = [Schedule]()
        guard let userid = UserManager.shared.getFireBaseUID() else {return}
        FireBaseConnect.databaseRef.child("users").child(userid).observeSingleEvent(of: .value) { (snapshot) in
            if let userData = snapshot.value as? [String: Any] {
                guard let username = userData["username"] as? String else {return}
                guard let email = userData["email"] as? String  else {return}
                guard let id = userData["uid"]  as? String  else {return}
                guard let photo = userData["photoUrl"] as? String else {return}
                guard let scheudle = userData["schedule"] as? [String: Any] else {return}
                for index in scheudle {
                    if let scheduleIndex = index.value as? [String: Any] {
                        guard let name = scheduleIndex["name"] as? String else {return}
                        guard let id = scheduleIndex["uid"] as? String else {return}
                        let schedule = Schedule(uid: id, name: name)
                        ScheduleUidArray.append(schedule)
                    }
                }
                let userInfo = User(email: email, photo: photo, schedule: ScheduleUidArray, uid: id, userName: username)
             //   self.getScheduleContent(uid: userInfo.schedule)
            }
        }
    }
*/

    // 到FireBase  schedules 撈使用者的post的 Scheudle內容
    func getScheduleContent() {
       guard let userid = UserManager.shared.getFireBaseUID() else {return}
        scheduleDataArray.removeAll()
             FireBaseConnect
                .databaseRef
                .child(Constants.FireBaseSchedules)
                .queryOrdered(byChild: "host")
                .queryEqual(toValue: userid)
                .observe(.childAdded, with: { (snapshot) in
                 //放background做
//                    DispatchQueue.global(qos: .background).async{
                        guard    let scheduleInfo =  snapshot.value as? [String: Any] else {return}
                        guard    let uid = scheduleInfo["uid"] as? String else {return}
                        guard    let name  = scheduleInfo["name"] as? String else {return}
                        guard    let date  = scheduleInfo["date"] as? String else {return}
                        guard    let days  = scheduleInfo["days"] as? String else {return}

                        let schedule = ScheduleInfo(uid: uid, date: date, name: name, days: days)
                        self.scheduleDataArray.append(schedule)
                        self.scheduleDataArray.sort(by: {$0.date < $1.date})

                        NotificationCenter.default.post(
                            name: .scheduleInfo,
                            object: nil)
//                    }
                })
           }
      }
