//
//  User.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/3.
//  Copyright © 2018年 Annie. All rights reserved.
//

import Foundation

struct User {
    var email: String
    var photo: String
    var schedule: [Schedule]
    var uid: String
    var userName: String
}

struct UserInfo {
    var email: String
    var photoUrl: String
    var uid: String
    var userName: String
}

struct Schedule {
    var uid: String
    var name: String
}

struct ScheduleInfo {
    var uid: String
    var date: String
    var name: String
    var days: String
}

struct DateInfo {
    var weekDay: Int
    var date: String
    var dayth: String
}

struct Destination {
    var name: String
    var time: String
    var category: String
    var latitude: Double
    var longitude: Double
    var query: String
    var uid: String
}

enum Locaion {
    case myLocation
    case destinationLocation
}
