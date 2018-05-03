//
//  Schedule.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/2.
//  Copyright © 2018年 Annie. All rights reserved.
//

import FirebaseDatabase


class scheduleManager {
    
   
    static let shared = scheduleManager()
    private init (){}
    
     

   //  guard let userid = UserManager.shared.getFireBaseUID() else {return}
   
    func findmyid(ok:@escaping(Bool)->()){
         guard let userid = UserManager.shared.getFireBaseUID() else {return}
        
        fireBaseConnect.databaseRef.child("users").queryOrdered(byChild: "uid").queryEqual(toValue: userid).observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot)
            ok(true)
        }
    }
    
    //寫入Schedule資料
    func saveScheduleInfo(scheduleName:String, scheudleDate:String, scheduleDay:String) {
        guard let userid = UserManager.shared.getFireBaseUID() else {return}
        
        let scheduleUid = fireBaseConnect.databaseRef.childByAutoId().key
        let scheduleInfo = ["name": scheduleName,"date":scheudleDate, "days":scheduleDay]
        fireBaseConnect.databaseRef.child("schedules").child(scheduleUid).setValue(scheduleInfo)
        //users裡新增scheduleid
         let  scheudlecontent = ["uid":scheduleUid,"name":scheduleName]
        fireBaseConnect.databaseRef.child("users").child(UserManager.shared.getFireBaseUID()!).child("schedule").child(scheduleUid).setValue(scheudlecontent)
        

            NotificationCenter.default.post(name: .switchtoSchedulePage, object: nil)
        }
    }


//取users裡cheudel uid 再在Schedule撈資料

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
       
        getSchedulecontent(uid: userInfo.schedule)
        }
    }
}



func getSchedulecontent(uid: [Schedule]){
    for index in uid {
        print(index.uid)
        fireBaseConnect.databaseRef.child("schedules").child(index.uid).observe(.value) { (snapshot) in
           print(snapshot)
        }
    }
    
    
}
