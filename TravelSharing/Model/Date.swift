//
//  Date.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/7.
//  Copyright © 2018年 Annie. All rights reserved.
//

import Foundation

class DateModel{
    
    static let sharded = DateModel()
   
    
    
    let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.dateFormat = "yyyy MM dd"
        return dateFormatter
    }()
    
}
