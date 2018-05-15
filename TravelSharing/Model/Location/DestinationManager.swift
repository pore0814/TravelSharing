//
//  LocationManager.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/7.
//  Copyright © 2018年 Annie. All rights reserved.
//

import Foundation

protocol DestinationManagerDelegate: class {
    func manager(_ manager :  DestinationManager, didGet schedule:[Destination])
}

struct DestinationManager{
    
    var delegate : DestinationManagerDelegate?
    
    func getDestinationData() {
        var destinationArray = [Destination]()
        guard let userid = UserManager.shared.getFireBaseUID() else {return}
        FireBaseConnect
            .databaseRef
            .child(Constants.FireBaseSchedules)
            .child("-LCBuqrtebBfGAT8iis_")
            .child("destination")
            .queryOrdered(byChild: "date")
            .queryEqual(toValue: "2018 05 11")
            .observe(.childAdded, with: { (snapshot) in
                
                guard  let destinationInfo =  snapshot.value as? [String: Any] else{return}
                guard  let category = destinationInfo["category"] as? String else{return}
                guard  let time  = destinationInfo["time"] as? String else{return}
                guard  let name  = destinationInfo["name"] as? String else{return}
                guard  let latitude  = destinationInfo["lat"] as? Double else{return}
                guard  let longitude = destinationInfo["long"] as? Double else {return}
                print("37",latitude)
                
                
                let destination =  Destination(name: name, time: time, category: category, latitude: latitude,longitude :longitude)
                print(destination)
                destinationArray.append(destination)
                print(destinationArray)
                destinationArray.sort(by: {$0.time < $1.time})
                
                DispatchQueue.main.async {
                    self.delegate?.manager(self,  didGet: destinationArray)
                }
            })
    }
}
