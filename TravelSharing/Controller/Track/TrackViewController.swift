//
//  TrackViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/17.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SVProgressHUD

class  TrackViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var googleMapsView: GMSMapView!
    @IBOutlet weak var googleMapStreetView: GMSPanoramaView!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //因為ＧＰＳ功能很耗電,所以被敬執行時關閉定位功能
        locationManager.stopUpdatingLocation()
    }

    var destinationManager = DestinationManager()

    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        //創建 locationManager
        //  locationManager = CLLocationManager()
        //配置 locationManager
        locationManager.delegate = self
        //詢問使用者權限
        locationManager.requestWhenInUseAuthorization()
        //開始接收目前位置資訊
        locationManager.startUpdatingLocation()

        locationManager.startMonitoringSignificantLocationChanges()

        self.googleMapsView.isMyLocationEnabled = true

        self.googleMapsView.settings.myLocationButton = true
    }

    // MARK: CLLocation Manager Delegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

        print("Error while get location\(error)")

    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let location = locations.last

        let camera = GMSCameraPosition.camera(
            withLatitude: (location?.coordinate.latitude)!,
            longitude: (location?.coordinate.longitude)!, zoom: 17.0)

        self.locationManager.stopUpdatingHeading()

    }
}
