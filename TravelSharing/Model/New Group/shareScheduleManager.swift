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

                guard  let aaa = snapshot.value as? [String: Any] else {return}
                for ggg in aaa {
                    guard  var ccc = ggg.value as? [String: Any] else {return}
                   // let aaaa = ["host": "ddddddd"] as? [String:Any]
                    ccc.updateValue(friendId, forKey: "host")

                    print(ccc)
                    self.savevalue(value: ccc)
                }
            })
      }

    func savevalue(value: [String: Any]) {
            let autoKey = FireBaseConnect.databaseRef.childByAutoId().key
        var aaa = value
        aaa.updateValue(autoKey, forKey: "uid")
        print(aaa)
        FireBaseConnect.databaseRef
            .child(Constants.FireBaseSchedules)
            .child(autoKey )
            .setValue(aaa)
    }
}
