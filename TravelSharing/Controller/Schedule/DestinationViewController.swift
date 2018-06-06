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
    var cellExpanded: Bool = false
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
    var userLocation:CLLocation?
    var cellIndexPath:IndexPath?
    var distanceVC:DistanceViewController?
    

    
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

    }
    
    func initTableView(){
        let nib = UINib(nibName: "DestinationTableViewCell", bundle: nil)

        tableView.register(nib, forCellReuseIdentifier: "DestinationTableViewCell")
        tableView.separatorStyle = .none

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

            if indexPath.row == tag {

                if cellExpanded {
                     return fullscreen.height * 0.6

                } else if indexPath.row != previous {

                    return fullscreen.height * 0.6
                }
            }
             return 75
         }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return testArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

      guard let cell = tableView.dequeueReusableCell(withIdentifier: "DestinationTableViewCell") as? DestinationTableViewCell
                        else {return UITableViewCell()}
                cell.categoryImage.image = UIImage(named: testArray[indexPath.row].category)
                cell.categoryLabel.text = testArray[indexPath.row].category
                cell.daysLabel.text = testArray[indexPath.row].time
                cell.nameLabel.text = testArray[indexPath.row].name
                cell.mapView.clear()
                cell.mapViewCell(latitude: testArray[indexPath.row].latitude,
                                 longitude: testArray[indexPath.row].longitude,
                                 destination: testArray[indexPath.row].name)
                cell.deleteBtn.addTarget(self, action: #selector(deleteTapBtn(_:)), for: .touchUpInside)

                cell.mapView.bringSubview(toFront: cell.deleteBtn)
                cell.mapView.bringSubview(toFront: cell.drawPathBtn)
                cell.mapView.bringSubview(toFront: cell.googleMapBtn)
                cell.mapView.bringSubview(toFront: cell.distanceBtn)
                cell.delegate = self
                cell.indexPath = indexPath
                cell.selectionStyle =  .none
        return cell
    }

@objc    func deleteTapBtn(_ sender: UIButton) {
// Fetch Item
      //  guard let superview = sender.superview,
      //     let cell = superview.superview as? DestinationTableViewCell else {return}

//刪除Destination Alert
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false)
    
            let alertView = SCLAlertView(appearance: appearance)

                alertView.addButton("確定") {
                        guard let scheduleId = self.scheduleUid, let dayth = self.dayths else {return}

                        self.destinationManger.deleteDestinationInfo(scheduleUid: self.scheduleUid!, dayth: dayth ,
                                                                     destinationUid: self.testArray[self.tag!].uid)
                        self.testArray.remove(at: self.tag!)
                        self.tableView.deleteRows(at: [self.indexPathInGlobal!], with: .automatic)
                        self.tableView.reloadData()
                }
                alertView.addButton("取消") {}
                alertView.showSuccess("", subTitle: NSLocalizedString("確定刪除?", comment: ""))
            }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tag = indexPath.row
            indexPathInGlobal = indexPath
//展開
            guard let selectedCell =  tableView.cellForRow(at: indexPath) as? DestinationTableViewCell else {return}

                    if cellExpanded {        //關
                        cellExpanded = false
                        selectedCell.direction.image = UIImage(named: "down-arrow")
                    } else if cellExpanded == false{
                        cellExpanded = true //打開
                        selectedCell.direction.image = UIImage(named: "up")
//                    } else if indexPath.row != previous {
                        
        }

            tableView.beginUpdates()
            tableView.endUpdates()
            previous = tag
    }
    func callDistanceVC(){

        let storyboard = UIStoryboard(name: "Schedule", bundle: nil)

        guard let distanceViewController = storyboard.instantiateViewController(withIdentifier: "DistanceViewController") as? DistanceViewController else {return}
 
        guard let userlocation = userLocation,let cellindexPath = cellIndexPath else {return}
        
        distanceManager
            .getDestinationDateAndTime(myLocaion:userlocation,
                                       endLocation:testArray[cellindexPath .row],
                                       completion:{ (data: DistanceAndTime) in

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
         }


//extension DestinationViewController: DestinationManagerDelegate, CLLocationManagerDelegate, GMSMapViewDelegate {

extension DestinationViewController: showDistanceDelegate,DestinationManagerDelegate{
    func callDistanceView(_ cell: DestinationTableViewCell, myLocation: CLLocation, at index: IndexPath) {
        userLocation = myLocation
        cellIndexPath = index
        callDistanceVC()
    }
    //Delegate 拿資料
    func manager(_ manager: DestinationManager, didGet schedule: [Destination]) {
            testArray = schedule
            tableView.reloadData()
    }
}
