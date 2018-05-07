//
//  AddLocationViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/5.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class AddLocationViewController: UIViewController {

    //@IBOutlet weak var stackview: UIStackView!

    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var categoryText: UITextField!
    @IBOutlet weak var timeText: UITextField!
    
    @IBOutlet weak var placeText: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    
     var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        //https://stackoverflow.com/questions/30991822/whats-the-swift-3-animatewithduration-syntax
      stackView.center.x = self.view.frame.width + 200
        UIView.animate(withDuration: 2.0, delay: 1.0, usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 30,
                       options: [] ,
                       animations: {
                  self.stackView.center.x = self.view.frame.width / 2
        }, completion: nil)

      getTime()
        
//        locationManager = CLLocationManager()
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//        locationManager.startMonitoringSignificantLocationChanges()
        
    
        categoryText.text = "景點"
        
        
}
    
    
    

    func getTime() {
        let date = Date()
        let calendar = Calendar.current

//        let year = calendar.component(.year, from: date)
//        let month = calendar.component(.month, from: date)
//        let day = calendar.component(.day, from: date)
//
//        dateText.text = "\(year)-\(month)-\(day)"

        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        timeText.text = "\(hour):\(minutes)"

    }
    
   
    
    @IBAction func spotBtn(_ sender: Any) {
        categoryText.text = "景點"
    }
    
    @IBAction func restaurantBtn(_ sender: Any) {
         categoryText.text = "餐廳"
    }
    
    @IBAction func hotelBtn(_ sender: Any) {
     categoryText.text = "住宿"
    }
    
    
    
    @IBAction func searchLocation(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        self.locationManager.startUpdatingLocation()
        self.present(autocompleteController, animated: true, completion: nil)
    }
    
}

//Search Location  (Auto complete)
extension AddLocationViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 15.0)
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
//        self.googleMapsView.camera = camera
        
        //顯示在TextField
        placeText.text = place.name
        print(camera)
        self.dismiss(animated: true, completion: nil) // dismiss after select place
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error auto complete\(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
}
    
    
    
    
}
