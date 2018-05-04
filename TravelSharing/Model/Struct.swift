//
//  User.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/3.
//  Copyright © 2018年 Annie. All rights reserved.
//

import Foundation

struct User {
    var email:String
    var photo:String
    var schedule :[Schedule]
    var uid:String
    var userName : String
}


struct Schedule{
    var uid:String
    var name:String
}


struct ScheduleInfo{
    var uid : String
    var date: String
    var name: String
    var days: String
}
