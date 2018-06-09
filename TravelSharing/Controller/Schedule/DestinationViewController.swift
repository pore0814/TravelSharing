//
//  TestViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/14.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SCLAlertView

class DestinationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var tag: Int?
    var previous: Int?
    var dayths: String?
    var scheduleUid: String?
    let cellSpacingHeight: CGFloat = 5
    var testArray = [Destination]()
    var schedulePassDataToDestination: ScheduleInfo?
    var destinationManger = DestinationManager()
    var distanceManager = DistanceManager()
    var lat: Double?
    var long: Double?
    var indexPathInGlobal: IndexPath?
    var userLocation: CLLocation?
    var distanceVC: DistanceViewController?
    var destinationCell: DestinationTableViewCell?
    var gmsPolyline: GMSPolyline?
    var locationManager = CLLocationManager()
    var locationstart     = CLLocation()
    var destinationLocaion = CLLocation()
    var showInfo =  false
    var cellExpanded:Bool = false
    var oldPolylin:GMSPolyline?
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        destinationManger.delegate = self

        guard let dayth = dayths, let scheduleuid = scheduleUid else {return}
        destinationManger.getDestinationInfo(destinationUid: scheduleuid, dayth: dayth)

        setUpTableView()

        configureMapDelegate()

    }

    func setUpTableView() {
        let nib = UINib(nibName: "DestinationTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DestinationTableViewCell")
        tableView.separatorStyle = .none
    }

    func configureMapDelegate() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        
        let indexPath = IndexPath(row: 0, section: 0)
        guard let indexpath = indexPathInGlobal else {return}
        guard let cell = tableView.cellForRow(at: indexPath) as? DestinationTableViewCell else {return}
        
        let camera = GMSCameraPosition.camera(withLatitude: -7.9293122, longitude: 112.5879156, zoom: 15.0)
        
        cell.mapView.camera = camera
        cell.mapView.isMyLocationEnabled = true
        cell.mapView.settings.myLocationButton = true
        cell.mapView.settings.compassButton = true
        cell.mapView.settings.zoomGestures = true
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let fullscreen = UIScreen.main.bounds

        if let selectedCell = tableView.cellForRow(at: indexPath) as? DestinationTableViewCell{
               selectedCell.direction.image = UIImage(named: "down-arrow")
            
            if indexPath.row == tag {
                if cellExpanded {
                    selectedCell.direction.image = UIImage(named: "up")
                    return fullscreen.height * 0.6
                } else if indexPath.row != previous {
                    selectedCell.direction.image = UIImage(named: "up")
                    return fullscreen.height * 0.6
                }
            }
        }
            return 75
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DestinationTableViewCell") as? DestinationTableViewCell   else {return UITableViewCell()}

            cell.categoryImage.image = UIImage(named: testArray[indexPath.row].category)
            cell.categoryLabel.text = testArray[indexPath.row].category
            cell.daysLabel.text = testArray[indexPath.row].time
            cell.nameLabel.text = testArray[indexPath.row].name
            cell.mapView.clear()
            cell.mapViewCell(lat: testArray[indexPath.row].latitude, long: testArray[indexPath.row].longitude, name: testArray[indexPath.row].name)
            cell.deleteBtn.addTarget(self, action: #selector(deleteTapBtn(_:)), for: .touchUpInside)
            cell.drawPathBtn.addTarget(self, action: #selector(drawpathBtn(_:)), for: .touchUpInside)
            cell.googleMapBtn.addTarget(self, action: #selector(googleMapBtn(_:)), for: .touchUpInside)

            cell.mapView.bringSubview(toFront: cell.deleteBtn)
            cell.mapView.bringSubview(toFront: cell.drawPathBtn)
            cell.mapView.bringSubview(toFront: cell.googleMapBtn)
            cell.mapView.bringSubview(toFront: cell.distanceBtn)
            cell.mapView.bringSubview(toFront: cell.previousSpotBtn)
            cell.delegate = self
            cell.selectionStyle =  .none
        return cell
    }

    @objc func googleMapBtn(_ sender: UIButton){}
    
    @objc func drawpathBtn(_ sender: UIButton){ }

    @objc func deleteTapBtn(_ sender: UIButton) {
        let alert = Alertmanager1.shared.showCheck(with: "確定刪除?", message: "", delete: {
            self.delete()
        }) {
            print("cancel")
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tag = indexPath.row
        indexPathInGlobal = indexPath
        guard let selectedCell =  tableView.cellForRow(at: indexPath) as? DestinationTableViewCell else {return}
        
        if cellExpanded {
            cellExpanded = false
        } else if cellExpanded == false{
            cellExpanded = true
        }
       
        
        
        tableView.beginUpdates()
        tableView.endUpdates()
        previous = tag
    }

    func callDistanceVC() {
        let storyboard = UIStoryboard(name: "Schedule", bundle: nil)
        guard let distanceViewController = storyboard.instantiateViewController(withIdentifier: "DistanceViewController") as? DistanceViewController else {return}
        guard let cellindexPath = indexPathInGlobal else {return}

            distanceManager
                .getDestinationDateAndTime(myLocaion: locationstart,
                                           endLocation: testArray[cellindexPath.row],
                                           completion: { (data: DistanceAndTime) in
                if data != nil {
                    distanceViewController.distanceKmLabel.text = data.distance
                    distanceViewController.timeMinsLabel.text = data.time
                    distanceViewController.destinationNamer.text = self.testArray[cellindexPath.row].name
                }
            })
        add(distanceViewController)

        distanceVC = distanceViewController
        distanceViewController.view.frame = self.view.frame
        distanceViewController.removeBtn.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }

    @objc func buttonClicked(sender: UIButton) {
        guard let vc = distanceVC else {return}
        removeFromOtherChild(vc)
    }
    
    // MARK: private func  Alert  delet動作
    private func delete() {

        guard let scheduleId = self.scheduleUid, let dayth = self.dayths else {return}
        self.destinationManger.deleteDestinationInfo(scheduleUid: self.scheduleUid!, dayth: dayth ,
                                                     destinationUid: self.testArray[self.tag!].uid)
        self.testArray.remove(at: self.tag!)
        self.tableView.deleteRows(at: [self.indexPathInGlobal!], with: .automatic)
        self.tableView.reloadData()
    }
}

//extension DestinationViewController: DestinationManagerDelegate, CLLocationManagerDelegate, GMSMapViewDelegate {

extension DestinationViewController: showDistanceDelegate, DestinationManagerDelegate,GMSMapViewDelegate, CLLocationManagerDelegate
{
   
    
    
    

    // MARK: CLLocation Manager Delegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while get location\(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let camera = GMSCameraPosition.camera(
            withLatitude: (location?.coordinate.latitude)!,
            longitude: (location?.coordinate.longitude)!, zoom: 5)
        
        guard let lat = location?.coordinate.latitude, let long = location?.coordinate.longitude else {return}
        //MyLocation
        locationstart = CLLocation(latitude: lat, longitude: long)
        self.locationManager.stopUpdatingHeading()
    }
    
    // Mark: - GMSMapViewDelegate
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        mapView.isMyLocationEnabled = true
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        mapView.isMyLocationEnabled = true
        
        if (gesture) {
            mapView.selectedMarker = nil
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapView.isMyLocationEnabled = true
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("coordinatio\(coordinate)")
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        return false
    }
    
    //MARK:- delegate
    
    func managerMyLocationdrawPath(_ manager: DestinationManager, getPolyline polyline: GMSPolyline) {
        oldPolylin?.map = nil
        guard let indexpath = indexPathInGlobal else {return}
        gmsPolyline = polyline
        guard let  cell = tableView.cellForRow(at: indexpath) as? DestinationTableViewCell else {return}
        destinationLocaion = CLLocation(latitude: testArray[indexpath.row].latitude, longitude: testArray[indexpath.row].longitude)
        
        gmsPolyline!.strokeColor = UIColor.blue
        gmsPolyline!.strokeWidth = 5
        gmsPolyline!.map = cell.mapView
        
        if let myLocation = cell.mapView.myLocation {
                        let path = GMSMutablePath()
                        path.add(myLocation.coordinate)
                        path.add(destinationLocaion.coordinate)
            
                        let bounds = GMSCoordinateBounds(path: path)
                        cell.mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 40))
            oldPolylin = polyline
        }
    }
    
   
    func managerPreviousSpotDrawPath(_ manager: DestinationManager, getPolyline polyline: GMSPolyline) {
        oldPolylin?.map = nil
        guard let indexpath = indexPathInGlobal else {return}
        gmsPolyline = polyline
        guard let  cell = tableView.cellForRow(at: indexpath) as? DestinationTableViewCell else {return}
       let  startLcoation = CLLocation(latitude: testArray[indexpath.row].latitude, longitude: testArray[indexpath.row].longitude)
        destinationLocaion = CLLocation(latitude: testArray[indexpath.row - 1].latitude, longitude: testArray[indexpath.row - 1].longitude)
        
        gmsPolyline!.strokeColor = UIColor.blue
        gmsPolyline!.strokeWidth = 5
        gmsPolyline!.map = cell.mapView
        
  
        
        let path = GMSMutablePath()
        path.add(startLcoation.coordinate)

        path.add(destinationLocaion.coordinate)
        
        let bounds = GMSCoordinateBounds(path: path)
        cell.mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 40))
        

        oldPolylin = polyline
      
//         let path = GMSMutablePath()
//        path.add(startLcoation.coordinate)
//        path.add(destinationLocaion.coordinate)
//        let bounds = GMSCoordinateBounds(path: path)
//        let update = GMSCameraUpdate.fit(bounds, withPadding: 60)
//        cell.mapView.animate(with: update)
        
//        if let myLocation = cell.mapView.myLocation {
//            let path = GMSMutablePath()
//
//            path.add(startLcoation.coordinate)
//            path.add(destinationLocaion.coordinate)
//
//            let bounds = GMSCoordinateBounds(path: path)
//            cell.mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 40))
//        }
        cell.mapViewCell(lat: testArray[indexpath.row - 1].latitude, long: testArray[indexpath.row - 1].longitude, name: testArray[indexpath.row - 1].name)
    }
    func manager(_ manager: DestinationManager, didGet schedule: [Destination]) {
        testArray = schedule
        tableView.reloadData()
    }
    
    func callGoogleMap() {
        guard let index = indexPathInGlobal else {return}
        if (UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)) {
            UIApplication.shared.openURL(NSURL(string:
                "comgooglemaps://?saddr=&daddr=\(Float(testArray[index.row].latitude)),\(Float(testArray[index.row].longitude))&directionsmode=driving")! as URL)
        } else {
            NSLog("Can't use com.google.maps://")
        }
    }
    
    func callFunctionTodrawPath() {
        guard let cellindexPath = indexPathInGlobal else {return}
        destinationManger.drawPath(myLocaion: locationstart, endLocation: testArray[cellindexPath.row])
    }
    
    func callDistanceView() {
        callDistanceVC()
    }
    
    func callpreviousSpot() {
        guard let cellindexPath = indexPathInGlobal else {return}
        if cellindexPath.row > 0 {
            destinationManger.drawPathPreviousSpot(startLocation: testArray[cellindexPath.row - 1], endLocation: testArray[cellindexPath.row])
        }else {
            AlertManager.showError(title: "沒有上一個景點哦", subTitle: "")
        }
            
    }
    

    
    
}




