//
//  Week.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/15.
//  Copyright © 2018年 Annie. All rights reserved.
//

import Foundation

enum WeekDay:Int{
    case Mon = 2,Tues,Wed,Thur,Fri,Sat,Sun
}

func getWeekDayStr(aa:Int) -> String{
    switch aa{
    case WeekDay.Mon.rawValue:
        return "週一"
    case WeekDay.Tues.rawValue:
        return "週二"
    case WeekDay.Wed.rawValue:
        return "週三"
    case WeekDay.Thur.rawValue:
        return "週四"
    case WeekDay.Fri.rawValue:
        return "週五"
    case WeekDay.Sat.rawValue:
        return "週六"
    default:
        return "週日"
    }
    return "Error"
}

