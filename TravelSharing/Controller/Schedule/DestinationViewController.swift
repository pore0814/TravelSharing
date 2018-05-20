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

//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        let fff = tableView.frame
//        let frrr = UIEdgeInsetsInsetRect(fff, UIEdgeInsetsMake(10, 10, 10, 10))
//        tableView.frame = frrr
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        destinationManger.delegate = self
        guard let dayth = dayths, let scheduleuid = scheduleUid else {
            return

        }
        destinationManger.getDestinationInfo(destinationUid: scheduleuid, dayth: dayth)

        let nib = UINib(nibName: "DistinationTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DistinationTableViewCell")

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
        guard let  cell = tableView.dequeueReusableCell(withIdentifier: "DistinationTableViewCell") as? DistinationTableViewCell else {return UITableViewCell()}
        cell.dateLabel.text = testArray[indexPath.row].category
        cell.daysLabel.text = testArray[indexPath.row].time
        cell.nameLabel.text = testArray[indexPath.row].name
        cell.mapViewCell(latitude: testArray[indexPath.row].latitude, longitude: testArray[indexPath.row].longitude, destination: testArray[indexPath.row].name)
        cell.deleteBtn.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        cell.selectionStyle =  .none
        return cell
    }

@objc    func didTapButton(_ sender: UIButton) {
// Fetch Item
        if let superview = sender.superview, let cell = superview.superview as? DistinationTableViewCell {
            cell.deleteBtn.isHidden = false
        }
    print(testArray[sender.tag].uid)
    
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tag = indexPath.row
        print("-----------")
        print(testArray[indexPath.row].uid)
        guard   let selectedCell =  tableView.cellForRow(at: indexPath) as?            DistinationTableViewCell else {return}

//cellExpanded is a flag to determine if the current cell selected has been expanded or not.
        if cellExpanded {
                    cellExpanded = false
             selectedCell.deleteBtn.isHidden = true
                } else {
                 selectedCell.deleteBtn.isHidden = false
                    cellExpanded = true
                }
//Then, after always call tableView.beginUpdates() and tableView.endUpdates() and it will trigger the delegate function of TableView heightForRowAt to determine what height value should we return or not
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
