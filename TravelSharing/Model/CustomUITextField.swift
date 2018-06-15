//
//  CustomUITextField.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/6/13.
//  Copyright © 2018年 Annie. All rights reserved.
//

import Foundation
import UIKit  // don't forget this

class CustomUITextField: UITextField {

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {

        if action == "paste:" {

            return false
        }

        return super.canPerformAction(action, withSender: sender)

    }
}
