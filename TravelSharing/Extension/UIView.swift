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
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 10
       // self.layer.cornerRadius = 10
    }

    func setConerRectWithBorder() {
     //    self.layer.borderWidth = 1
        self.layer.masksToBounds = true
       // self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.cornerRadius = 25
        
    }

    func setRounded10(){
         self.layer.masksToBounds = true
         self.layer.cornerRadius = 10
         self.layer.borderWidth = 1
         self.layer.borderColor = UIColor.darkGray.cgColor
    }
    func setRounded() {
       // self.layer.borderWidth = 1
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.cornerRadius = self.frame.width / 2
    }

    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 0.1]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        layer.insertSublayer(gradientLayer, at: 0)
  }
}
