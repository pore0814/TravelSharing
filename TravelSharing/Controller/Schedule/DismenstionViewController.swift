//
//  DismenstionViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/12.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class DismenstionViewController: UIViewController,GMSMapViewDelegate {
    var lat: Double?
    var long: Double?
    
    

    @IBOutlet weak var streetView: GMSPanoramaView!
    @IBOutlet weak var mapView: GMSMapView!
    
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("26",lat)
        print("27",long)
        
        
        GMSPanoramaService().requestPanoramaNearCoordinate(CLLocationCoordinate2D(latitude: 25.034028,longitude: 121.56426)) { (pano, error) in
            if error != nil{
                print("\(error)")
                return
            }
            self.streetView.panorama = pano
        }

        let camera = GMSCameraPosition.camera(withLatitude:25.034028, longitude:121.56426, zoom: 16)
        mapView.camera = camera
        mapView?.animate(to: camera)
        
        let position = CLLocationCoordinate2D(latitude: 25.034028,longitude: 121.56426)
        let marker = GMSMarker(position: position)
        marker.title = "Hello World"
        marker.map = mapView
        
        mapView.delegate = self

    }

    @IBAction func mpaViewPressed(_ sender: Any) {
//        streetView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
//        streetView.layoutSubviews()
        mapView.frame = CGRect(x: 0, y: 0, width:  self.view.frame.width, height:  self.view.frame.height)
       // mapView.isHidden = false
        print("aaa")
       
    }
    
    
    @IBAction func streetViewPressed(_ sender: Any) {
        streetView.frame = CGRect(x: 0, y: 0, width:  self.view.frame.width, height:  self.view.frame.height)
         print("bbbb")
    }
    

}
