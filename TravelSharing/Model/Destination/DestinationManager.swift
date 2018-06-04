//
//  LocationManager.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/7.
//  Copyright © 2018年 Annie. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Alamofire

protocol DestinationManagerDelegate: class {
    func manager(_ manager: DestinationManager, didGet schedule: [Destination])
}

struct DestinationManager {
    var delegate: DestinationManagerDelegate?
    var totalDistanceInMeters: UInt = 0
    var totalDistance: String!
    var totalDurationInSeconds: UInt = 0
    var totalDuration: String!
////第一次登入會產生的範例
//    func savefisrtDestinationInfo(uid: String) {
//
//        let destinationUid = FireBaseConnect.databaseRef.childByAutoId().key
//        let destinationInfo = ["category": "景點",
//                               "lat": 23.003012, "long": 120.211601,
//                               "name": "台南公園", "query": "2019 01 01_11:00",
//            "time": "11:00", "uid": destinationUid ] as [String: Any]
//
//        FireBaseConnect.databaseRef
//            .child(Constants.FireBaseSchedules)
//            .child(uid)
//            .child("destination")
//            .child("Day1")
//            .child(destinationUid)
//            .setValue(destinationInfo)
//    }

//SaveDate
    func saveDestinationInfo(uid: String, dayth: String, destination: Destination) {

        print("101-------")
        let destinationUid = FireBaseConnect.databaseRef.childByAutoId().key
        let destinationInfo = ["category": destination.category,
                               "lat": destination.latitude, "long": destination.longitude,
                               "name": destination.name, "query": destination.query,
                               "time": destination.time, "uid": destinationUid] as [String: Any]

        FireBaseConnect.databaseRef
            .child(Constants.FireBaseSchedules)
            .child(uid)
            .child("destination")
            .child(dayth)
            .child(destinationUid)
            .setValue(destinationInfo)
    }

//getData
    func getDestinationInfo(destinationUid: String, dayth: String) {
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
                        guard  let query = destinationInfo["query"] as? String else {return}
                        guard  let uid = destinationInfo["uid"] as? String else {return}

                        let destination =  Destination(name: name, time: time, category: category, latitude: latitude, longitude: longitude, query: query, uid: uid)
                        destinationInfoArray.append(destination)
                        destinationInfoArray.sort(by: {$0.time < $1.time})
                    }
                    DispatchQueue.main.async {
                        self.delegate?.manager(self, didGet: destinationInfoArray)
                    }
                }
            })
        }
//Delete
    func deleteDestinationInfo(scheduleUid: String, dayth: String, destinationUid: String) {
       FireBaseConnect.databaseRef.child("schedules")
                                    .child(scheduleUid)
                                    .child("destination")
                                    .child(dayth)
                                    .child(destinationUid)
                                    .removeValue { error, _ in
                                                    print(error)
                                    }
        }
// get DistanceAndTime
    func getDestinationDateAndTime(completion:@escaping(DistanceAndTime) -> Void) {
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=25.042837,121.564879&destination=25.058232,121.520560&mode=driving"

        Alamofire.request(url).responseJSON { response in
            //print(response.value)
            guard let result = response.value as? [String: Any],

            let routes = result["routes"] as? [[String: Any]],
                let route = routes.first,
            let legs = route["legs"] as? [[String: Any]],
            let leg = legs.first,
            let distances = leg["distance"] as? [String: Any],
            let durations = leg["duration"] as? [String: Any],
            let distance = distances["text"] as? String ,
            let duration = durations["text"] as? String else {return}

            let distanceInfo = DistanceAndTime(distance: distance, time: duration)

             completion(distanceInfo)

    }
   }
}
