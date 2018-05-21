//
//  String.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/1.
//  Copyright © 2018年 Annie. All rights reserved.
//

import Foundation

extension String {

        var isEmail: Bool {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
            let emailTest  = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
            return emailTest.evaluate(with: self)
    }
}
