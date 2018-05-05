//
//  UIImage.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/4/30.
//  Copyright © 2018年 Annie. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {

    
    func setRounded(){
       // self.layer.borderWidth = 1
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.cornerRadius = 10
    }

}
