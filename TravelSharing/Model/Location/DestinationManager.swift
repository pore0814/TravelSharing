//
//  LocationManager.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/7.
//  Copyright © 2018年 Annie. All rights reserved.
//

import Foundation
import FirebaseDatabase


protocol DestinationManagerDelegate: class {
    func manager(_ manager: DestinationManager, didGet schedule: [Destination])
}

struct DestinationManager {

    var delegate: DestinationManagerDelegate?

    func getDestinationData() {
        var destinationArray = [Destination]()
        guard let userid = UserManager.shared.getFireBaseUID() else {return}
        FireBaseConnect
            .databaseRef
            .child(Constants.FireBaseSchedules)
            .child("-LCBuqrtebBfGAT8iis_")
            .child("destination")
            .queryOrdered(byChild: "date")
            .queryEqual(toValue: "2018 05 11")
            .observe(.childAdded, with: { (snapshot) in

                guard  let destinationInfo =  snapshot.value as? [String: Any] else {return}
                guard  let category = destinationInfo["category"] as? String else {return}
                guard  let time  = destinationInfo["time"] as? String else {return}
                guard  let name  = destinationInfo["name"] as? String else {return}
                guard  let latitude  = destinationInfo["lat"] as? Double else {return}
                guard  let longitude = destinationInfo["long"] as? Double else {return}
                guard  let date = destinationInfo["date"] as? String else {return}

                let destination =  Destination(name: name, time: time, date: date, category: category, latitude: latitude, longitude: longitude)
                destinationArray.append(destination)
                destinationArray.sort(by: {$0.time < $1.time})

                DispatchQueue.main.async {
                    self.delegate?.manager(self, didGet: destinationArray)
                }
            })
    }

    func getDestinationInfo(){
        let uid = "-LCBuqrtebBfGAT8iis_"
        let dates = ["2018 05 11","2018 05 12","2018 05 13","2018 05 14"]
        var destinationArray : [Destination] = []
      
        
            for index in 0...(dates.count - 1){
                FireBaseConnect
                .databaseRef
                .child(Constants.FireBaseSchedules)
                .child(uid)
                .child("destination")
                .queryOrdered(byChild: "query")
                .queryStarting(atValue: dates[index]+"_00:00")
                .queryEnding(atValue: dates[index]+"_24:00")
                .observe(.childAdded, with: { (snapshot) in
                    guard  let destinationInfo =  snapshot.value
                                                    as? [String: Any] else {return}
                    guard  let category = destinationInfo["category"]
                                                    as? String else {return}
                    guard  let time  = destinationInfo["time"]
                                                    as? String else {return}
                    guard  let name  = destinationInfo["name"]
                                                    as? String else {return}
                    guard  let latitude  = destinationInfo["lat"]
                                                    as? Double else {return}
                    guard  let longitude = destinationInfo["long"]
                                                    as? Double else {return}
                    guard  let date = destinationInfo["date"]  as? String else {return}

                    let destination =  Destination(name: name,
                                                   time: time,
                                                   date: date,
                                                   category: category,
                                                   latitude: latitude,
                                                   longitude: longitude)
                    print("--------88")
                    print(destination)
                    
                    destinationArray.append(destination)
//                    destinationArray.sort(by: {$0.time < $1.time})
                    
                })
           }
       }
   }
