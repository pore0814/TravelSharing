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

class DestinationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GMSMapViewDelegate {

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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        destinationManger.delegate = self
        
        guard let dayth = dayths, let scheduleuid = scheduleUid else {return}
        destinationManger.getDestinationInfo(destinationUid: scheduleuid, dayth: dayth)

        let nib = UINib(nibName: "DestinationTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DestinationTableViewCell")
        tableView.separatorStyle = .none
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
        cell.dateLabel.text = testArray[indexPath.row].category
        cell.daysLabel.text = testArray[indexPath.row].time
        cell.nameLabel.text = testArray[indexPath.row].name
        cell.mapViewCell(latitude: testArray[indexPath.row].latitude, longitude: testArray[indexPath.row].longitude, destination: testArray[indexPath.row].name)
        cell.deleteBtn.addTarget(self, action: #selector(deleteTapBtn(_:)), for: .touchUpInside)
        cell.selectionStyle =  .none
        return cell
    }

    
@objc    func deleteTapBtn(_ sender: UIButton) {
// Fetch Item
        if  let superview = sender.superview,
            let cell = superview.superview as? DestinationTableViewCell{
                    cell.deleteBtn.isHidden = false
            }


//刪除Destination
        guard let scheduleId = scheduleUid,let dayth = dayths else{return}
    
        destinationManger.deleteDestinationInfo(scheduleUid: scheduleUid!, dayth:dayth ,
                                                destinationUid: testArray[sender.tag].uid)
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tag = indexPath.row
//展開
        guard   let selectedCell =  tableView.cellForRow(at: indexPath) as? DestinationTableViewCell else {return}
        if cellExpanded {
                    cellExpanded = false
             selectedCell.deleteBtn.isHidden = true
                } else {
                 selectedCell.deleteBtn.isHidden = false
                    cellExpanded = true
                }
        tableView.beginUpdates()
        tableView.endUpdates()
        previous = tag
    }

}

extension DestinationViewController: DestinationManagerDelegate {

    func manager(_ manager: DestinationManager, didGet schedule: [Destination]) {
        testArray = schedule
        tableView.reloadData()
    }

}
