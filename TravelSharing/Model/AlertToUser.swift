//
//  Alert.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/1.
//  Copyright © 2018年 Annie. All rights reserved.
//

import Foundation
import SCLAlertView

class AlertToUser {

    static let shared = AlertToUser()
           let alert = SCLAlertView()

    func alerTheUserPurple(title: String, message: String) {
        alert.showEdit(title, subTitle: message)
    }

}
