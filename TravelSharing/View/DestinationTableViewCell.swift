//
//  ScheuleRightTableViewCell.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/3.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON
import Firebase
import SCLAlertView

protocol showDistanceDelegate: class {
    func callDistanceView()
    func callFunctionTodrawPath()
}

class DestinationTableViewCell: UITableViewCell, CLLocationManagerDelegate{
    //, GMSMapViewDelegate, CLLocationManagerDelegate
    @IBOutlet weak var distanceBtn: UIButton!
    @IBOutlet weak var googleMapBtn: UIButton!
    @IBOutlet weak var drawPathBtn: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var rightUiview: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var direction: UIImageView!
    
    
    var destinationData :Destination?
    
    weak var delegate: showDistanceDelegate?
 //   var indexPath: IndexPath! = nil
  var locationManager = CLLocationManager()
    // var locationSelected = Location.myLocaion
    var locationstart     = CLLocation()
   var destinationLocaion = CLLocation()
    var distanceManager = DistanceManager()
    var destinationManager = DestinationManager()
    //var showInfo =  false
    //var distanceVC: DistanceViewController?
    
//    var totalDistanceInMeters: UInt = 0
//    var totalDistance: String!
//    var totalDurationInSeconds: UInt = 0
//    var totalDuration: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //rightUiview.setConerRectWithBorder()
        rightUiview.setShadow()
        //  rightUiview.setGradientBackground(colorOne: UIColor.blue, colorTwo: UIColor.white)
        
        mapDelegateAndInitiation()
    }
    
    @IBAction func deleteBtn(_ sender: Any) {
    }

    @IBAction func distanceInfoBtn(_ sender: UIButton) {
        self.delegate?.callDistanceView()
    }
    
    @IBAction func drawRouteBtn(_ sender: Any) {
       self.delegate?.callFunctionTodrawPath()
       // guard let endLocationData =  destinationData else {return}
//        destinationManager.drawPath(myLocaion: locationstart, endLocation:endLocationData)
//
//        if let myLocation = mapView.myLocation {
//            let path = GMSMutablePath()
//            path.add(myLocation.coordinate)
//            path.add(destinationLocaion.coordinate)
//            //add other coordinates
//            //path.addCoordinate(model.coordinate)
//
//            let bounds = GMSCoordinateBounds(path: path)
//            mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 40))
//        }
    }
    //Google導航
    @IBAction func googleMapBtn(_ sender: Any) {
        if (UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)) {
            UIApplication.shared.openURL(NSURL(string:
                "comgooglemaps://?saddr=&daddr=\(Float(destinationLocaion.coordinate.latitude)),\(Float(destinationLocaion.coordinate.longitude))&directionsmode=driving")! as URL)
        } else {
            NSLog("Can't use com.google.maps://")
        }
    }
    
    func mapDelegateAndInitiation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        
        //        let camera = GMSCameraPosition.camera(withLatitude: -7.9293122, longitude: 112.5879156, zoom: 15.0)
        //        self.mapView.camera = camera
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.myLocationButton = true
        //        self.mapView.settings.compassButton = true
        //        self.mapView.settings.zoomGestures = true
    }
    
   //func mapViewCell(latitude: Double, longitude: Double, destination: String) {
    func mapViewCell(data:Destination) {
        destinationData = data
        destinationLocaion = CLLocation(latitude: data.latitude, longitude: data.longitude)
        let camera = GMSCameraPosition.camera(withLatitude: data.latitude, longitude: data.longitude, zoom: 16)
        let cellMapview = mapView
        cellMapview?.camera = camera
        cellMapview?.animate(to: camera)
        
        let position = CLLocationCoordinate2D(latitude: data.latitude, longitude: data.longitude)
        let marker = GMSMarker(position: position)
        marker.title = data.name
        marker.map = cellMapview
    }
    
    //    // MARK: CLLocation Manager Delegate
    //    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    //        print("Error while get location\(error)")
    //    }
    //
    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //                let location = locations.last
    //                let camera = GMSCameraPosition.camera(
    //                    withLatitude: (location?.coordinate.latitude)!,
    //                    longitude: (location?.coordinate.longitude)!, zoom: 5)
    //
    //         guard let lat = location?.coordinate.latitude, let long = location?.coordinate.longitude else {return}
    //                locationstart = CLLocation(latitude: lat, longitude: long)
    //                self.locationManager.stopUpdatingHeading()
    //    }
    
    //// Mark: - GMSMapViewDelegate
    //    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
    //         mapView.isMyLocationEnabled = true
    //    }
    //
    //    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
    //         mapView.isMyLocationEnabled = true
    //
    //            if (gesture) {
    //                mapView.selectedMarker = nil
    //            }
    //    }
    //
    //    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    //         mapView.isMyLocationEnabled = true
    //         return false
    //    }
    //
    //    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
    //        print("coordinatio\(coordinate)")
    //    }
    //
    //    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
    //        mapView.isMyLocationEnabled = true
    //        mapView.selectedMarker = nil
    //
    //        return false
    //    }
}





