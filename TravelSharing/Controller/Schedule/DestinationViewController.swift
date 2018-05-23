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
    var locationManager = CLLocationManager()
    var lat: Double?
    var long: Double?
    var indexPathInGlobal: IndexPath?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        destinationManger.delegate = self

        guard let dayth = dayths, let scheduleuid = scheduleUid else {return}
        destinationManger.getDestinationInfo(destinationUid: scheduleuid, dayth: dayth)

        let nib = UINib(nibName: "DestinationTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DestinationTableViewCell")
        tableView.separatorStyle = .none

    }

    func initMapLocaionManager() {
        locationManager = CLLocationManager()
        //配置 locationManager
        locationManager.delegate = self
        //詢問使用者權限
        locationManager.requestAlwaysAuthorization()
        //開始接收目前位置資訊
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == tag {
            if cellExpanded {
               return 400
                } else if indexPath.row != previous {
                  return 400
                }
             }
              return 70
        }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let  cell = tableView.dequeueReusableCell(withIdentifier: "DestinationTableViewCell") as? DestinationTableViewCell else {return UITableViewCell()}
            cell.categoryImage.image = UIImage(named: testArray[indexPath.row].category)
            cell.daysLabel.text = testArray[indexPath.row].time
            cell.nameLabel.text = testArray[indexPath.row].name
            cell.mapViewCell(latitude: testArray[indexPath.row].latitude,
                             longitude: testArray[indexPath.row].longitude,
                             destination: testArray[indexPath.row].name)
            cell.deleteBtn.addTarget(self, action: #selector(deleteTapBtn(_:)), for: .touchUpInside)
            cell.mapView.bringSubview(toFront: cell.deleteBtn)
            cell.selectionStyle =  .none
        return cell
    }

@objc    func deleteTapBtn(_ sender: UIButton) {
// Fetch Item
      //  guard let superview = sender.superview,
      //     let cell = superview.superview as? DestinationTableViewCell else {return}

//刪除Destination
        guard let scheduleId = scheduleUid, let dayth = dayths else {return}

        destinationManger.deleteDestinationInfo(scheduleUid: scheduleUid!,
                                                dayth: dayth ,
                                            destinationUid: testArray[tag!].uid)

        testArray.remove(at: tag!)
        tableView.deleteRows(at: [indexPathInGlobal!], with: .automatic)
        tableView.reloadData()

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tag = indexPath.row
        indexPathInGlobal = indexPath
//展開
        guard   let selectedCell =  tableView.cellForRow(at: indexPath) as? DestinationTableViewCell else {return}
           if cellExpanded {
                cellExpanded = false
            } else {
                cellExpanded = true
            }

        tableView.beginUpdates()
        tableView.endUpdates()
        previous = tag
    }

    @IBAction func inviteFrineds(_ sender: Any) {
        let allUsersPage = UIStoryboard.allUsersStoryboard().instantiateInitialViewController()

        present(allUsersPage!, animated: true, completion: nil)
    }
}

extension DestinationViewController: DestinationManagerDelegate, CLLocationManagerDelegate, GMSMapViewDelegate {
    //Delegate 拿資料
    func manager(_ manager: DestinationManager, didGet schedule: [Destination]) {
        testArray = schedule
        tableView.reloadData()
    }
}
