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
import GoogleMaps
import GooglePlaces
import Firebase
import SwiftyJSON

protocol DestinationManagerDelegate: class {
    func manager(_ manager: DestinationManager, didGet schedule: [Destination])
    func managerdrawPath(_ manager: DestinationManager, getPolyline polyline: GMSPolyline)
}

struct DestinationManager {
    var delegate: DestinationManagerDelegate?
    var totalDistanceInMeters: UInt = 0
    var totalDistance: String!
    var totalDurationInSeconds: UInt = 0
    var totalDuration: String!

//SaveDate
    func saveDestinationInfo(uid: String, dayth: String, destination: Destination) {

        let destinationUid = FireBaseConnect.databaseRef.childByAutoId().key
        let destinationInfo = ["category": destination.category,
                               "lat": destination.latitude,
                               "long": destination.longitude,
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

           FireBaseConnect
                .databaseRef
                .child("schedules")
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
    
    
    
    func drawPath(myLocaion: CLLocation, endLocation: Destination) {
        Analytics.logEvent("drawPath", parameters: nil)
        
        print("drawPath--------------------")
        print("myLocation", myLocaion)
        print("endLocation", endLocation)
        
        let origin = "\(myLocaion.coordinate.latitude),\(myLocaion.coordinate.longitude)"
       // let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
         let destination = "\(endLocation.latitude),\(endLocation.longitude)"
       let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
        
         //let url = "https://maps.googleapis.com/maps/api/directions/json?origin=25.034028,121.56426&destination=22.9998999,120.2268758&mode=driving"
        
        Alamofire.request(url).responseJSON { response in
            
            let json = try? JSON(data: response.data!)
            
            let routes = json!["routes"].arrayValue
            print(json)
            print("routes-----------------")
            
            // print route using Polyline
            for route in routes {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let distance = routeOverviewPolyline?["distance"]?.stringValue
                // let duration = routeOverviewPolyline?["duration"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                let polyline = GMSPolyline.init(path: path)
                self.delegate?.managerdrawPath(self, getPolyline: polyline)
                polyline.strokeWidth = 5
                polyline.strokeColor = UIColor.blue
          //      polyline.map = self.mapView
                print("----------------------------------------")
            }
        }
    }
    
}
