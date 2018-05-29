//
//  DistanceManager.swift
//  
//
//  Created by 王安妮 on 2018/5/29.
//

import UIKit
import Alamofire
import GoogleMaps
import GooglePlaces

class DistanceManager {

    var locationManager = CLLocationManager()
    var locationSelected = Location.myLocaion
 
   func getDestinationDateAndTime(myLocaion: CLLocation, endLocation: CLLocation,completion:@escaping(DistanceAndTime
    ) -> Void){
//    func getDestinationDateAndTime(myLocaion: CLLocation, endLocation: CLLocation) {
//    func getDestinationDateAndTime(){
        let origin = "\(myLocaion.coordinate.latitude),\(myLocaion.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
     let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
   //      let url = "https://maps.googleapis.com/maps/api/directions/json?origin=25.042837,121.564879&destination=25.058232,121.520560&mode=driving"

        Alamofire.request(url, method: .get).responseJSON { response in
            //print(response.value)
            guard let result = response.value as? [String: Any],

                let routes = result["routes"] as? [[String: Any]],
                let route = routes.first,
                let legs = route["legs"] as? [[String: Any]],
                let leg = legs.first,
                let distances = leg["distance"] as? [String: Any],
                let durations = leg["duration"] as? [String: Any],
                let distance = distances["text"] as? String,
                let duration = durations ["text"] as? String  else {return}
          
            
            let distanceInfo = DistanceAndTime(distance: distance, time: duration)
            print("class--------")
            completion(distanceInfo)
        }
    }
}
