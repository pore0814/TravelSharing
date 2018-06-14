//
//  GradientView.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/23.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {

    @IBInspectable var firstColor: UIColor = UIColor.clear {
        
        didSet {
            
           updateView()
        }
    }

    @IBInspectable var secondColor: UIColor = UIColor.clear {
        
        didSet {
            
            updateView()
            
        }
    }

    override class var layerClass: AnyClass {
        
        get {
            
            return CAGradientLayer.self
            
        }
    }

    func updateView() {
        
        guard let layer = self.layer as? CAGradientLayer else {return}
        
        layer.colors = [firstColor.cgColor, secondColor.cgColor]
        
    }

}
