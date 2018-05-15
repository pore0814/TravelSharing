//
//  DateFormatter.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/11.
//  Copyright © 2018年 Annie. All rights reserved.
//

import Foundation

class TSDateFormatter {
    
    let dateformate = DateFormatter()
    

    
    private func getYYMMDD(indexNumber: ScheduleInfo) -> Date {
        dateformate.dateFormat = "yyyy MM dd"
        
        guard let startDate = dateformate.date(from:indexNumber.date),
            let day = Int(indexNumber.days) else { return Date(timeIntervalSince1970: 0)}
        
        return startDate
    }
    
    private func getMMDD(indexNumber: ScheduleInfo) -> [String] {
        
        let startdate = getYYMMDD(indexNumber: indexNumber)
        
        var dateInfoMMDD = [String]()
        guard let days = Int(indexNumber.days) else { return [""] }
        
        for i in 1...days {
            let endate = Calendar.current.date(byAdding:.day , value:i , to: startdate)
            
            dateformate.dateFormat = "MM/dd"
            let a = dateformate.string(from: endate!)
            
            dateInfoMMDD.append(a)
        }
        
        return dateInfoMMDD
        
    }
    
    private func getEE(indexNumber: ScheduleInfo) -> [Int] {
        
        let startdate = getYYMMDD(indexNumber: indexNumber)
        
        var dateInfoEE = [Int]()
        guard let days = Int(indexNumber.days) else { return [0] }
        
        for i in 0...days {
            let endate = Calendar.current.date(byAdding:.day , value:i , to: startdate)
            let weekday = Calendar.current.component(.weekday, from: endate!)
            
            dateInfoEE.append(weekday)
        }
        return dateInfoEE
    }
    
    func getTSDate(indexNumer: ScheduleInfo) -> [DateInfo] {
        let aArray = getMMDD(indexNumber: indexNumer)
        
        let weekArray = getEE(indexNumber: indexNumer)
        
        var TSDateArray = [DateInfo]()
        
        for i in 0...aArray.count - 1 {
            let TSDate = DateInfo(weekDay: weekArray[i], date: aArray[i])
            TSDateArray.append(TSDate)
        }
        return TSDateArray
    }
    
}
