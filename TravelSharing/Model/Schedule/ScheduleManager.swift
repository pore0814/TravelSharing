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
    var scheduleDataInfo :ScheduleInfo?
    var scheduleDataArray = [ScheduleInfo]()
    
  
    //新增Schedule資料
    func saveScheduleInfo(uid: String?, scheduleName: String, scheudleDate: String, scheduleDay: String) {
        //User Id
        guard let userid = UserManager.shared.getFireBaseUID() else {return}
      
        let  scheduleUid = FireBaseConnect.databaseRef.childByAutoId().key
       
        let scheduleInfo = ["uid":scheduleUid,"name": scheduleName, "date": scheudleDate, "days": scheduleDay]
        FireBaseConnect.databaseRef.child(Constants.FireBaseSchedules).child(userid).child(scheduleUid).setValue(scheduleInfo)

//
//          //資料寫入後Notification通知跳頁
//            NotificationCenter.default.post(name: .switchtoSchedulePage, object: nil)
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
    
    // 到FireBase  schedules 撈使用的post的 Scheudle內容
    func getScheduleContent() {
       guard let userid = UserManager.shared.getFireBaseUID() else {return}
       // scheduleDataArray.removeAll()
            FireBaseConnect
                .databaseRef
                .child(Constants.FireBaseSchedules)
                .child(userid)
                .observe(.childAdded, with: { (snapshot) in
                 //放background做
//                    DispatchQueue.global(qos: .background).async{
                        guard    let scheduleInfo =  snapshot.value as? [String: Any] else{return}
                        guard    let uid = scheduleInfo["uid"] as? String else{return}
                        guard    let name  = scheduleInfo["name"] as? String else{return}
                        guard    let date  = scheduleInfo["date"] as? String else{return}
                        guard    let days  = scheduleInfo["days"] as? String else{return}
                        
                        let schedule =
                               ScheduleInfo(uid: uid, date: date, name: name, days: days)
                        print("-----")
                        print("79",self.scheduleDataArray.count)
                        self.scheduleDataArray.append(schedule)
                        self.scheduleDataArray.sort(by: {$0.date < $1.date})
                        print("89",self.scheduleDataArray)

                        NotificationCenter.default.post(
                            name: .scheduleInfo,
                            object: nil)
//                    }
                  
                })
           }
    
    
    
    func getScheduleContent_value() {
        guard let userid = UserManager.shared.getFireBaseUID() else {return}
        // scheduleDataArray.removeAll()
        FireBaseConnect
            .databaseRef
            .child(Constants.FireBaseSchedules)
            .child(userid)
            .observe(.value)
                { (snapshot) in
                    
                print(snapshot.value)
                //放background做
                DispatchQueue.global(qos: .background).async{
                    guard    let scheduleInfo =  snapshot.value as? [String: Any] else{return}
                    for data in scheduleInfo {
                        print(data.value)
                        guard  let datadetail = data.value as? [String:String]  else{return}
           
                        guard    let uid = datadetail["uid"] as? String else{return}
                        guard    let name  = datadetail["name"] as? String else{return}
                        guard    let date  = datadetail["date"] as? String else{return}
                        guard    let days  = datadetail["days"] as? String else{return}
              
                        let schedule = ScheduleInfo(uid: uid, date: date, name: name, days: days)
                        print(schedule)
                        
                        
                    }

//
                  
//                    print("-----")
//                    print("79",self.scheduleDataArray.count)
//                    self.scheduleDataArray.append(schedule)
//                    self.scheduleDataArray.sort(by: {$0.date < $1.date})
//                    print("89",self.scheduleDataArray)
//
//                    NotificationCenter.default.post(
//                        name: .scheduleInfo,
//                        object: nil)
                }
                
            }
    }
    
    
    
    
    

    //刪除(同時刪除Schedule下的uid 和User下Schedule的uid)
    func deleteSchedule(scheduleId: String) {
      print("75", scheduleId)
        guard let userid = UserManager.shared.getFireBaseUID() else {return}
        /* 先刪除Schedule_id */ FireBaseConnect.databaseRef.child(Constants.FireBaseSchedules).child(scheduleId).removeValue { error, _ in
            /* 再刪除使用者Schedule下的Schedule_id  */
            if error == nil {
                FireBaseConnect.databaseRef.child(Constants.FireBaseUsers).child(userid).child(Constants.FireBaseSchedule).child(scheduleId).removeValue { error, _ in
                    if error != nil {
                        AlertToUser.shared.alerTheUserPurple(title: Constants.Wrong_Message, message: "刪除失敗")
                    }
                }
            }
        }
    }
}

