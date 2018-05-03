//
//  Schedule.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/2.
//  Copyright © 2018年 Annie. All rights reserved.
//

import FirebaseDatabase

struct ScheduleManager {
   static let shared = ScheduleManager()

    //寫入Schedule資料
    func saveScheduleInfo(scheduleName:String, scheudleDate:String, scheduleDay:String) {
        guard let userid = UserManager.shared.getFireBaseUID() else {return}
        let scheduleUid = fireBaseConnect.databaseRef.childByAutoId().key
        let scheduleInfo = ["name": scheduleName,"date":scheudleDate, "days":scheduleDay]
        fireBaseConnect.databaseRef.child("schedules").child(scheduleUid).setValue(scheduleInfo)
        //users裡新增schedule_id
         let  scheudlecontent = ["uid":scheduleUid,"name":scheduleName]
     fireBaseConnect.databaseRef.child("users").child(userid).child("schedule").child(scheduleUid).setValue(scheudlecontent)
        
          //資料寫入後Notification通知跳頁
            NotificationCenter.default.post(name: .switchtoSchedulePage, object: nil)
        }
 
//取users裡將使用者的schedule_id放到Array裡，再到Schedules裡將這些uid的內容撈出來
    func getUserInfo(){
        var ScheduleUidArray = [Schedule]()
        guard let userid = UserManager.shared.getFireBaseUID() else {return}
        fireBaseConnect.databaseRef.child("users").child(userid).observeSingleEvent(of: .value) { (snapshot) in
            if let userData = snapshot.value as? [String : Any]{
                guard let username = userData["username"] as? String else {return}
                guard let email = userData["email"] as? String  else {return}
                guard let id = userData["uid"]  as? String  else {return}
                guard let photo = userData["photoUrl"] as? String else {return}
                guard let scheudle = userData["schedule"] as? [String:Any] else {return}
                for index in scheudle {
                    if let scheduleIndex = index.value as? [String : Any]{
                        guard let name = scheduleIndex["name"] as? String else {return}
                        guard let id = scheduleIndex["uid"] as? String else {return}
                        let schedule = Schedule(uid: id, name: name)
                        ScheduleUidArray.append(schedule)
                    }
                }
                let userInfo = User(email: email, photo: photo, schedule: ScheduleUidArray, uid: id, userName: username)
                self.getScheduleContent(uid: userInfo.schedule)
            }
        }
    }
    //傳入使用者Scheudle_id , 到Schedules裡撈資料，撈完資料發通知傳資料到ScheduleViewController
    func getScheduleContent(uid: [Schedule]) {
        for index in uid {
            fireBaseConnect.databaseRef.child("schedules").child(index.uid).observe(.value) { (snapshot) in
                guard let scheduleInfo =  snapshot.value as? [String:Any] else {return}
                NotificationCenter.default.post(name: .scheduleInfo, object: nil, userInfo:scheduleInfo )
            }
        }
    }
}



