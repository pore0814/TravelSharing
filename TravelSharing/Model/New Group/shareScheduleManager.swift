//
//  shareScheduleManager.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/6/4.
//  Copyright © 2018年 Annie. All rights reserved.
//

import Foundation

class ShareScheduleManager {
    //var delegate: GetUserInfoManagerDelegate?

    // 到FireBase  schedules 撈使用者的post的 Scheudle內容
    func getMyScheduleId(scheduleId: String, friendId: String) {
        guard let userid = UserManager.shared.getFireBaseUID() else {return}
              FireBaseConnect
                    .databaseRef
                    .child("schedules")
                    .queryOrderedByKey()
                    .queryEqual(toValue: scheduleId)
                    .observe(.value, with: { (snapshot) in

                guard  let allSchedules = snapshot.value as? [String: Any] else {return}
                for allschedule in allSchedules {
                    guard  var schedule = allschedule.value as? [String: Any] else {return}
                    schedule.updateValue(friendId, forKey: "host")

                    self.savevalue(value: schedule)
                }
            })
      }

    func savevalue(value: [String: Any]) {
            let autoKey = FireBaseConnect.databaseRef.childByAutoId().key
        
        var shareValue = value
        shareValue.updateValue(autoKey, forKey: "uid")

        FireBaseConnect.databaseRef
            .child(Constants.FireBaseSchedules)
            .child(autoKey)
            .setValue(shareValue)
    }
}
