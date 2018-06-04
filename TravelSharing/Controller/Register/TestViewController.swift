//
//  TestViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/29.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire

class TestViewController: UIViewController, CLLocationManagerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        drawPath()
    }

    func drawPath() {

        print("aaaa")

//
//        let origin = "\(myLocaion.coordinate.latitude),\(myLocaion.coordinate.longitude)"
//        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
//
//        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"

      let strUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=25.058154,121.520560&destination=25.041263,121.565061&mode=driving"

        var dist = ""

        let url = URL(string: strUrl)!
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "")

                return
            }
            if let result = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any],
                let routes = result["routes"] as? [[String: Any]],
                let route = routes.first,
                let legs = route[""] as? [[String: Any]],
                let leg = legs.first,
                let distance = leg["distance"] as? [String: Any],
                let distanceText = distance["text"] as? String {

                dist = distanceText
            }
           print(dist)
        })
        task.resume()
        }

}
