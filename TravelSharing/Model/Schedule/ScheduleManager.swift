//
//  Schedule.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/2.
//  Copyright © 2018年 Annie. All rights reserved.
//

import FirebaseDatabase

class ScheduleManager {
   static let shared = ScheduleManager()

    //新增Schedule資料
    func saveScheduleInfo(uid:String?,scheduleName:String, scheudleDate:String, scheduleDay:String) {
        //User Id
        guard let userid = UserManager.shared.getFireBaseUID() else {return}
        var scheduleUid: String?
        if uid == nil{
         scheduleUid = FireBaseConnect.databaseRef.childByAutoId().key
        }else{
           scheduleUid = uid
        }
        
        let scheduleInfo = ["name": scheduleName,"date":scheudleDate, "days":scheduleDay,"uid":scheduleUid]
        FireBaseConnect.databaseRef.child(Constants.FireBaseSchedules).child(scheduleUid!).setValue(scheduleInfo)

        
        //users裡新增schedule_id
         let  scheudlecontent = ["uid":scheduleUid,"name":scheduleName]
     FireBaseConnect.databaseRef.child(Constants.FireBaseUsers).child(userid).child(Constants.FireBaseSchedule).child(scheduleUid!).setValue(scheudlecontent)
        
          //資料寫入後Notification通知跳頁
            NotificationCenter.default.post(name: .switchtoSchedulePage, object: nil)
        }
 
//取users裡將使用者的schedule_id放到Array裡，再到Schedules裡將這些uid的內容撈出來
    func getUserInfo(){
        var ScheduleUidArray = [Schedule]()
        guard let userid = UserManager.shared.getFireBaseUID() else {return}
        FireBaseConnect.databaseRef.child("users").child(userid).observeSingleEvent(of: .value) { (snapshot) in
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
            FireBaseConnect.databaseRef.child(Constants.FireBaseSchedules).child(index.uid).observe(.value) { (snapshot) in
                print("56",snapshot)
                guard let scheduleInfo =  snapshot.value as? [String:Any] else {return}
                NotificationCenter.default.post(name: .scheduleInfo, object: nil, userInfo:scheduleInfo )
            }
        }
    }
    
    //刪除(同時刪除Schedule下的uid 和User下Schedule的uid)
    func deleteSchedule(scheduleId:String){
      print("75",scheduleId)
        guard let userid = UserManager.shared.getFireBaseUID() else {return}
        /* 先刪除Schedule_id */ FireBaseConnect.databaseRef.child(Constants.FireBaseSchedules).child(scheduleId).removeValue { error, _ in
            /* 再刪除使用者Schedule下的Schedule_id  */
            if error == nil {
                FireBaseConnect.databaseRef.child(Constants.FireBaseUsers).child(userid).child(Constants.FireBaseSchedule).child(scheduleId).removeValue { error, _ in
                    if error != nil{
                        AlertToUser.shared.alerTheUserPurple(title: Constants.Wrong_Message, message: "刪除失敗")
                    }
                }
            }
        }
    }
    
}



