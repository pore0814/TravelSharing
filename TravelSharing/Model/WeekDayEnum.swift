//
//  Week.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/15.
//  Copyright © 2018年 Annie. All rights reserved.
//

import Foundation

enum WeekDay: Int {
    case mon = 2, tues, wed, thur, fri, sat, sun
}

func getWeekDayStr(weekDay: Int) -> String {
    switch weekDay {
    case WeekDay.mon.rawValue:
        return "週一"
    case WeekDay.tues.rawValue:
        return "週二"
    case WeekDay.wed.rawValue:
        return "週三"
    case WeekDay.thur.rawValue:
        return "週四"
    case WeekDay.fri.rawValue:
        return "週五"
    case WeekDay.sat.rawValue:
        return "週六"
    default:
        return "週日"
    }
}
