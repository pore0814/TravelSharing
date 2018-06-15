//
//  ButtonIBIn.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/25.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit

class ButtonIBIn: UIButton {

    @IBInspectable var conerRadius: CGFloat = 0.0 {

        didSet {

            layer.cornerRadius = conerRadius

            layer.masksToBounds = conerRadius > 0

        }
    }
}
