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

class DistinationTableViewCell: UITableViewCell, GMSMapViewDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var rightUiview: UIView!
    @IBOutlet weak var mapView: GMSMapView!

    override func awakeFromNib() {
        super.awakeFromNib()
        rightUiview.setShadow()
    }

    func mapViewCell(latitude: Double, longitude: Double, destination: String) {
       
        guard let lat = latitude as? Double,
              let long = longitude as? Double,
              let name = destination as? String else {return}

        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 16)
        let cellMapview = mapView
        cellMapview?.camera = camera
        cellMapview?.animate(to: camera)

        let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let marker = GMSMarker(position: position)
        marker.title = name
        marker.map = cellMapview!
    }

}
