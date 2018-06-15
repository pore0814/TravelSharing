//
//  Contents.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/1.
//  Copyright © 2018年 Annie. All rights reserved.
//

import Foundation

struct Constants {

    struct LoginAndRegister {
        static let Diff2Password = "二個密碼不同"
        static let InvalidEmail = "無效Email"
        static let PwdMoreThan6 = "密碼需大於6碼"
        static let CorrectInfo = "填寫正確的Email和密碼"
    }

    struct Destination {
        static let AddDestination = "新增目的地"
        static let StreetView = "才能觀看街景圖哦"
    }

    struct Map {
        static let YourLocation = "點選您所在位置"
        static let SettingYourLocation = "請到設定開啓定位功能"
        static let selected = ""
    }

    static let User = "users"
    static let Email = "email"
    static let Password = "password"
    static let PhotoUrl = "photoUrl"
    static let Uid = "uid"
    static let UserName = "username"

    static let ProfileImage = "profileImage"

    static let WrongMessage = "錯誤訊息"
    static let NoEmpty = "表格需填寫完整，不可為空白"
    static let FailToDelete = "刪除失敗"
    static let NoData = "目前無資料"

    struct Firebase {
        static let Schedules = "schedules"
        static let Schedule = "schedule"
        static let Users = "users"
    }

}
