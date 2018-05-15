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

class DistinationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,GMSMapViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    var cellExpanded: Bool = false
    var tag:Int?
    var previous: Int?
    
    var TestArray = [Destination]()
    var destinationManger = DestinationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        destinationManger.delegate = self
        destinationManger.getDestinationData()
        
        let nib = UINib(nibName: "DistinationTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DistinationTableViewCell")
        
        tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        if indexPath.row == tag {
            if cellExpanded {
               return 400
            }else if indexPath.row != previous
            {
              return 400
            }
         }
              return 65
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TestArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DistinationTableViewCell") as! DistinationTableViewCell

        cell.dateLabel.text = TestArray[indexPath.row].category
        cell.daysLabel.text = TestArray[indexPath.row].time
        cell.nameLabel.text = TestArray[indexPath.row].name
        cell.mapViewCell(latitude:TestArray[indexPath.row].latitude
            ,longitude:TestArray[indexPath.row].longitude, destination: TestArray[indexPath.row].name)
        cell.selectionStyle =  .none
    
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tag = indexPath.row
            //cellExpanded is a flag to determine if the current cell selected has been expanded or not.
            if cellExpanded{
                    cellExpanded = false
                }else  {
                    cellExpanded = true
                }
        //Then, after always call tableView.beginUpdates() and tableView.endUpdates() and it will trigger the delegate function of TableView heightForRowAt to determine what height value should we return or not
        tableView.beginUpdates()
        tableView.endUpdates()
        previous = tag
    
    }
}

extension DistinationViewController: DestinationManagerDelegate {
    
    func manager(_ manager: DestinationManager,  didGet schedule: [Destination]) {
        TestArray = schedule
        tableView.reloadData()
    }
    
}
