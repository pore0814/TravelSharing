//
//  Alert.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/1.
//  Copyright © 2018年 Annie. All rights reserved.
//

import Foundation
import SCLAlertView

struct AlertToUser {

    private static let alert = SCLAlertView()

    static func showError(title: String, subTitle: String) {

    self.alert.showError(title, subTitle: subTitle)
    }
}

struct AlertToUser1 {
    var alert = SCLAlertView()
    
}

class AlertToUserShared {
    static let shared = AlertToUserShared()
          var alert = SCLAlertView()
    
}
