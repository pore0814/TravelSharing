//
//  NavigationCotroller.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/11.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit

class TravelSharingNavigationController: UINavigationController {

    override func viewDidLoad() {
       // navigationBar.barTintColor = TravelSharingColor.tabBarTintColor.color()
        var colors = [UIColor]()
        colors.append(UIColor(red: 179/255, green: 255/255, blue: 224/255, alpha: 1))
        colors.append(UIColor(red: 77/255, green: 136/255, blue: 255/255, alpha: 1))
        navigationBar.setGradientBackground(colors: colors)
        arrangeShadowLayer()
    }

    private func arrangeShadowLayer() {
        self.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 4 )
        self.navigationBar.layer.shadowRadius = 4.0
        self.navigationBar.layer.shadowOpacity = 0.25
    }
}
//漸層
extension CAGradientLayer {

    convenience init(frame: CGRect, colors: [UIColor]) {
        self.init()
        self.frame = frame
        self.colors = []
        for color in colors {
            self.colors?.append(color.cgColor)
        }
        startPoint = CGPoint(x: 0, y: 0)
        endPoint = CGPoint(x: 1, y: 0)
    }

    func createGradientImage() -> UIImage? {

        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }

}

extension CAGradientLayer {
    class func gradientLayerForBounds(bounds: CGRect) -> CAGradientLayer {
        var layer = CAGradientLayer()
        layer.frame = bounds
        layer.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
        return layer
    }
}

extension UINavigationBar {
    func setGradientBackground(colors: [UIColor]) {
        var updatedFrame = bounds
        updatedFrame.size.height += self.frame.origin.y
        let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors)
        setBackgroundImage(gradientLayer.createGradientImage(), for: UIBarMetrics.default)
    }
}


