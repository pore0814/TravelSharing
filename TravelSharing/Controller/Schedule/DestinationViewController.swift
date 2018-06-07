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
    
    //----------

    var locationManager = CLLocationManager()

    var locationstart     = CLLocation()
    var destinationLocaion = CLLocation()
    var showInfo =  false
    
    var totalDistanceInMeters: UInt = 0
    var totalDistance: String!
    var totalDurationInSeconds: UInt = 0
    var totalDuration: String!
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        destinationManger.delegate = self

        guard let dayth = dayths, let scheduleuid = scheduleUid else {return}
        destinationManger.getDestinationInfo(destinationUid: scheduleuid, dayth: dayth)

        initTableView()
        
        mapDelegateAndInitiation()

    }

    func initTableView() {
        let nib = UINib(nibName: "DestinationTableViewCell", bundle: nil)

        tableView.register(nib, forCellReuseIdentifier: "DestinationTableViewCell")
        tableView.separatorStyle = .none

    }
    
    
    
    
    func mapDelegateAndInitiation() {
        
        
        
        
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

    

    //    func initMapLocaionManager() {
    //        locationManager = CLLocationManager()
    //        //配置 locationManager
    //        locationManager.delegate = self
    //        //詢問使用者權限
    //        locationManager.requestAlwaysAuthorization()
    //        //開始接收目前位置資訊
    //        locationManager.startUpdatingLocation()
    //    locationManager.startMonitoringSignificantLocationChanges()
    //    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let fullscreen = UIScreen.main.bounds
        
        if let selectedCell = tableView.cellForRow(at: indexPath) as? DestinationTableViewCell{
            selectedCell.direction.image = UIImage(named: "down-arrow")
    
            if indexPath.row == tag && indexPath.row != previous {
                selectedCell.direction.image = UIImage(named: "up")
                return fullscreen.height * 0.6
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
        cell.mapViewCell(data: testArray[indexPath.row])
        cell.deleteBtn.addTarget(self, action: #selector(deleteTapBtn(_:)), for: .touchUpInside)
        cell.drawPathBtn.addTarget(self, action: #selector(drawpathBtn(_:)), for: .touchUpInside)

        cell.mapView.bringSubview(toFront: cell.deleteBtn)
        cell.mapView.bringSubview(toFront: cell.drawPathBtn)
        cell.mapView.bringSubview(toFront: cell.googleMapBtn)
        cell.mapView.bringSubview(toFront: cell.distanceBtn)
        cell.delegate = self
       // cell.indexPath = indexPath
        cell.selectionStyle =  .none
        return cell
    }

   @objc func drawpathBtn(_ sender: UIButton){
    
    }
    
    
    @objc func deleteTapBtn(_ sender: UIButton) {
        // Fetch Item
        //  guard let superview = sender.superview,
        //     let cell = superview.superview as? DestinationTableViewCell else {return}

        //刪除Destination Alert
        //            let appearance = SCLAlertView.SCLAppearance(
        //                showCloseButton: false)
        //
        //            let alertView = SCLAlertView(appearance: appearance)
        //
        //
        //                alertView.addButton(Check.yes.setButtonTitle()) {
        //                    self.delete()
        //                }
        //                alertView.addButton(Check.no.setButtonTitle()) {}
        //                alertView.showSuccess("", subTitle: NSLocalizedString("確定刪除?", comment: ""))

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
    // MARK: private func
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
    func callFunctionTodrawPath() {
          guard let cellindexPath = indexPathInGlobal else {return}
        destinationManger.drawPath(myLocaion: locationstart, endLocation: testArray[cellindexPath.row])
    }
    
    func callDistanceView() {
       
        callDistanceVC()
    }
    
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
//        mapView.isMyLocationEnabled = true
//        mapView.selectedMarker = nil
        return false
    }
    
    //MARK:- delegate
    
    func managerdrawPath(_ manager: DestinationManager, getPolyline polyline: GMSPolyline) {
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
                        //add other coordinates
                        //path.addCoordinate(model.coordinate)
            
                        let bounds = GMSCoordinateBounds(path: path)
                        cell.mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 40))
                    }
        
        
        
        
    }
    
//    func callDistanceView(_ cell: DestinationTableViewCell, myLocation: CLLocation, at index: IndexPath) {
//        userLocation = myLocation
//        cellIndexPath = index
//        callDistanceVC()
//    }

    func manager(_ manager: DestinationManager, didGet schedule: [Destination]) {
        testArray = schedule
        tableView.reloadData()
    }
}


enum Check: String {

    case yes = "Yes"

    case no = "No"

    func setButtonTitle() -> String {
        switch self {
        case .yes:
            return "確定"
        case .no:
            return "不要喇～～～～"
        }
    }
}

