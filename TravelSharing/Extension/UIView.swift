//
//  UIView.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/9.
//  Copyright © 2018年 Annie. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    func setShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 10
        self.layer.cornerRadius = 10
    }

    func imageSetRounded() {
         self.layer.borderWidth = 1
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.cornerRadius = 10
    }

    func setCircle() {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.cornerRadius = self.frame.width / 2
    }

}
