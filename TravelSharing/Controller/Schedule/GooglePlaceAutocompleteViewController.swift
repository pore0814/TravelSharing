//
//  GooglePlaceAutocompleteViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/6.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class GooglePlaceAutocompleteViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

    @IBOutlet weak var googleMapsView: GMSMapView!
    @IBOutlet weak var googleMapStreetView: GMSPanoramaView!

    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()

        initGoogleMaps()
    }

    func initGoogleMaps() {
//        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
//        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//        mapView.isMyLocationEnabled = true
//        self.googleMapsView.camera = camera

        self.googleMapsView.delegate = self
        self.googleMapsView.isMyLocationEnabled = true
        self.googleMapsView.settings.myLocationButton = true

    }

//
//   @objc func searchTapped(){
//    let autocompleteController = GMSAutocompleteViewController()
//    autocompleteController.delegate = self
//    self.locationManager.startUpdatingLocation()
//    self.present(autocompleteController, animated: true, completion: nil)
//
//    }

   // MARK: CLLocation Manager Delegate

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while get location\(error)")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let camera = GMSCameraPosition.camera(
                                    withLatitude: (location?.coordinate.latitude)!,
                                    longitude: (location?.coordinate.longitude)!, zoom: 17.0)

        self.googleMapsView.animate(to: camera)
        self.locationManager.stopUpdatingHeading()
    }

    // MARK: GMSMapView Delegate
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.googleMapsView.isMyLocationEnabled = true
    }

    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        self.googleMapsView.isMyLocationEnabled = true
        if (gesture){
            mapView.selectedMarker = nil
        }
    }
}

extension GooglePlaceAutocompleteViewController: GMSAutocompleteViewControllerDelegate {

    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude,
                                              longitude: place.coordinate.longitude, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        print(camera)
        self.dismiss(animated: true, completion: nil) // dismiss after select place
        mapView.camera = camera
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error auto complete\(error)")
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }

}
