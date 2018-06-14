//
//  Round.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/4/30.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedUIImageView: UIImageView {
    @IBInspectable var round: Bool = true {
        didSet { self.setNeedsLayout() }
    }
    
    @IBInspectable var width: CGFloat = 1 {
        didSet { self.setNeedsLayout() }
    }
    
    @IBInspectable var color: CGColor = UIColor.gray.cgColor {
        didSet { self.setNeedsLayout() }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.clipsToBounds = true
        
        if round {
            self.layer.cornerRadius = self.frame.width / 2
        } else {
            self.layer.cornerRadius = 0
        }
        
    }
    
}
