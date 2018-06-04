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
    let alert = SCLAlertView()
}

struct AlertToUser1 {
    static var alert = SCLAlertView()
}

class AlerToUser2 {
    static let shared = AlerToUser2()
           let alert = SCLAlertView()

     func alertToUser(title: String, subTitle: String) {
           alert.showEdit(title, subTitle: subTitle)
    }

}
