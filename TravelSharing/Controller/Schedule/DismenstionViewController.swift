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

class DismenstionViewController: UIViewController, GMSMapViewDelegate {
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
        
    let barButton = UIBarButtonItem(image: UIImage(named: "check"), landscapeImagePhone: nil, style: .done, target: self, action: #selector(addTapped))
    self.navigationItem.rightBarButtonItem = barButton
        

        //街景圖
     GMSPanoramaService().requestPanoramaNearCoordinate(
            CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)) { (pano, error) in
                    if error != nil {
                        print("\(error)")
                            return
            }
            self.streetView.panorama = pano
        }
        
        
       
        
//手勢放大
//       let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBlurButton(recignizer:)))
//        tapGesture.numberOfTouchesRequired = 1
//        streetView.addGestureRecognizer(tapGesture)
//       streetView.isUserInteractionEnabled = true

// 在location 上顯示 Marker
        initGooglemap(latitude: latitude, longitude: longtitude, name: "Annie")
    }
    
 @objc   func addTapped(sender: AnyObject) {
        print("aaaa")
    }

    @IBAction func showBtn(_ sender: Any) {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.openURL(URL(string:
                "comgooglemaps://?center=40.765819,-73.975866&zoom=14&views=traffic")!)
        } else {
            print("Can't use comgooglemaps://");
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

//
//    @objc func tapBlurButton(recignizer: UITapGestureRecognizer) {
//        print("Please Help!")
//    }
//
//    @IBAction func mapViewFullScreenTaped(_ sender: Any) {
//        let fullScreen = UIScreen.main.bounds
//        mapView.frame = CGRect(x: 0, y: 0, width: fullScreen.width, height: fullScreen.height)
//        print("================")
//        print(fullScreen .width)
//        print(fullScreen .height)
//        print("aaa")
//    }
//
//    @IBAction func streedViewFullScreenTaped(_ sender: Any) {
//        let fullScreen = UIScreen.main.bounds
//        streetView.frame = CGRect(x: 0, y: 0, width: fullScreen.width, height: fullScreen.height)
//        print("================")
//        print(fullScreen .width)
//        print(fullScreen .height)
//    }
//
//    @IBAction func mpaViewPressed(_ sender: Any) {
////        streetView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
////        streetView.layoutSubviews()
//        let screen = UIScreen.main.bounds
//        mapView.frame = CGRect(x: 0, y: 0, width: screen.width, height: screen.height)
//        print("================")
//        print(screen.width)
//        print(screen.height)
//       // mapView.isHidden = false
//        print("aaa")
//
//    }
//
//    @IBAction func streetViewPressed(_ sender: Any) {
//        streetView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
//         print("bbbb")
//    }

}
