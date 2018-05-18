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

//    func getDestinationData() {
//        var destinationArray = [Destination]()
//        guard let userid = UserManager.shared.getFireBaseUID() else {return}
//        FireBaseConnect
//            .databaseRef
//            .child(Constants.FireBaseSchedules)
//            .child("-LCBuqrtebBfGAT8iis_")
//            .child("destination")
//            .queryOrdered(byChild: "date")
//            .queryEqual(toValue: "2018 05 11")
//            .observe(.childAdded, with: { (snapshot) in
//
//                guard  let destinationInfo =  snapshot.value as? [String: Any] else {return}
//                guard  let category = destinationInfo["category"] as? String else {return}
//                guard  let time  = destinationInfo["time"] as? String else {return}
//                guard  let name  = destinationInfo["name"] as? String else {return}
//                guard  let latitude  = destinationInfo["lat"] as? Double else {return}
//                guard  let longitude = destinationInfo["long"] as? Double else {return}
//                guard  let date = destinationInfo["date"] as? String else {return}
//                guard  let query = destinationInfo["query"] as? String else {return}
//
//                let destination =  Destination(name: name, time: time, date: date, category: category, latitude: latitude, longitude: longitude, query: query)
//                destinationArray.append(destination)
//                destinationArray.sort(by: {$0.time < $1.time})
//
//                DispatchQueue.main.async {
//                    self.delegate?.manager(self, didGet: destinationArray)
//                }
//            })
//    }

//SaveDate
    func saveDestinationInfo(uid: String, dayth: String, destination: Destination) {

        print("101-------")
        let destinationUid = FireBaseConnect.databaseRef.childByAutoId().key
        let destinationInfo = ["category": destination.category,
                                "date": destination.date, "lat": destination.latitude,
                                "long": destination.longitude, "name": destination.name,
                                "query": destination.query, "time": destination.time]
                                as [String: Any]

        FireBaseConnect.databaseRef
            .child(Constants.FireBaseSchedules)
            .child(uid)
            .child("destination")
            .child(dayth)
            .child(destinationUid)
            .setValue(destinationInfo)
    }
    
//getData
    func getDestinationInfo(destinationUid:String,dayth:String) {
        FireBaseConnect
            .databaseRef
            .child(Constants.FireBaseSchedules)
            .child(destinationUid)
            .child("destination/"+dayth).queryOrdered(byChild: "time")
            .observe(.value, with: { (snapshot) in

                var destinationInfoArray = [Destination]()

                if let values = snapshot.value as? NSDictionary {
                    for value in values.allValues {
                       // guard let destination = value as? [String:Any] else {return}
                        guard  let destinationInfo =  value as? [String: Any] else {return}
                        guard  let category = destinationInfo["category"] as? String else {return}
                        guard  let time  = destinationInfo["time"] as? String else {return}
                        guard  let name  = destinationInfo["name"] as? String else {return}
                        guard  let latitude  = destinationInfo["lat"] as? Double else {return}
                        guard  let longitude = destinationInfo["long"] as? Double else {return}
                        guard  let date = destinationInfo["date"] as? String else {return}
                        guard  let query = destinationInfo["query"] as? String else {return}

                        let destination =  Destination(name: name, time: time, date: date, category: category, latitude: latitude, longitude: longitude, query: query)
                        destinationInfoArray.append(destination)
                        print("----------99")
                        print(destinationInfoArray)
                        destinationInfoArray.sort(by: {$0.time < $1.time})
                    }
                    DispatchQueue.main.async {
                        self.delegate?.manager(self, didGet: destinationInfoArray)
                    }
                }
            })
        }
   }
