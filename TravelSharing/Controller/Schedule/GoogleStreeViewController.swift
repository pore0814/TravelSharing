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

class GoogleStreeViewController: UIViewController, GMSMapViewDelegate {
    var lat: Double?
    var long: Double?
    var name: String?

    @IBOutlet weak var streetView: GMSPanoramaView!
    @IBOutlet weak var mapView: GMSMapView!

    @IBOutlet weak var showBtn: UIButton!
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

    guard let latitude = lat, let longtitude = long else {return}

        //街景圖
     GMSPanoramaService().requestPanoramaNearCoordinate(
            CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)) { (pano, error) in
                    if error != nil {
                        
                        print("\(error)")
                        
                            return
            }
                
            self.streetView.panorama = pano
        }

// 在location 上顯示 Marker
        initGooglemap(latitude: latitude, longitude: longtitude, name: "Annie")
    }

    @IBAction func showBtn(_ sender: Any) {
        
        if (UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)) {
            UIApplication.shared.openURL(URL(string:
                "comgooglemaps://?center=40.765819,-73.975866&zoom=14&views=traffic")!)
        } else {
            print("Can't use comgooglemaps://")
        }
    }

    func initGooglemap(latitude: Double, longitude: Double, name: String) {

        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 16)
        
        mapView.camera = camera
        
        mapView?.animate(to: camera)

        let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let marker = GMSMarker(position: position)
        
        marker.title = name
        
        marker.map = mapView
        
        mapView.delegate = self

    }

}
