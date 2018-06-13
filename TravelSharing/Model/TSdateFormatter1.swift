//
//  TSdateFormatter1.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/15.
//  Copyright © 2018年 Annie. All rights reserved.
//

import Foundation

class TSDateFormatter1 {

    let dateformate = DateFormatter()

    func getYYMMDD(indexNumber: ScheduleInfo) -> [ScheduleDateInfo] {

        dateformate.dateFormat = "yyyy MM dd"
        dateformate.timeZone = TimeZone(abbreviation: "GMT+0:00")
        guard let startDate = dateformate.date(from: indexNumber.date),
              let  days     = Int(indexNumber.days) else {return []}

        print("----------")
        print("23", startDate)

        var TSDateArray = [ScheduleDateInfo]()
        if days == 0 {
            AlertManager.showEdit(title: "天數需大於0天", subTitle: "請到編輯重新設定")
        }else {
        for day in 0...days - 1 {
            guard let enddate = Calendar.current.date(byAdding: .day, value: day, to: startDate) else {return []}
            dateformate.dateFormat = "MM/dd"
            print("33", enddate)
            let weekday = Calendar.current.component(.weekday, from: enddate)
            print(weekday)

            let dayth = "Day"+String(day+1)

            let endDateStr = dateformate.string(from: enddate)
            let TSDate = ScheduleDateInfo(weekDay: weekday, date: endDateStr, dayth: dayth)
            TSDateArray.append(TSDate)
        }
        }
      return TSDateArray
    }
}
