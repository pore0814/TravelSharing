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

protocol showDistanceDelegate: class {
    func callDistanceView()
    func callFunctionTodrawPath()
    func callGoogleMap()
    func callpreviousSpot()
}

class DestinationTableViewCell: UITableViewCell, CLLocationManagerDelegate{

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
    
    @IBOutlet weak var previousSpotBtn: UIButton!
    
    
    weak var delegate: showDistanceDelegate?
    var locationManager = CLLocationManager()
    var locationstart     = CLLocation()
    var destinationLocaion = CLLocation()
    var distanceManager = DistanceManager()
    var destinationManager = DestinationManager()
    var destinationData :Destination?

    override func awakeFromNib() {
        super.awakeFromNib()

        rightUiview.setShadow()

        mapDelegateAndInitiation()
    }
    
    @IBAction func deleteBtn(_ sender: Any) {}
    

    @IBAction func distanceInfoBtn(_ sender: UIButton) {
        self.delegate?.callDistanceView()
    }

    @IBAction func drawRouteBtn(_ sender: Any) {
        self.delegate?.callFunctionTodrawPath()
    }

    //Google導航
    @IBAction func googleMapBtn(_ sender: Any) {
        self.delegate?.callGoogleMap()
    }
    
    @IBAction func previousSpotBtn(_ sender: Any) {
        self.delegate?.callpreviousSpot()
    }
    

    func mapDelegateAndInitiation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()

        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.myLocationButton = true
    }

    func mapViewCell(lat:Double,long:Double,name:String) {

        destinationLocaion = CLLocation(latitude: lat, longitude: long)
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 16)
        let cellMapview = mapView
        cellMapview?.camera = camera
        cellMapview?.animate(to: camera)

        let position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let marker = GMSMarker(position: position)
        marker.title = name
        marker.map = cellMapview
        
        
        
       
    }
}





