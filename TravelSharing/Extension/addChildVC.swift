//
//  addChildVC.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/6/6.
//  Copyright © 2018年 Annie. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func add(_ child: UIViewController) {
        addChildViewController(child)
        view.addSubview(child.view)
        child.didMove(toParentViewController: self)
    }

    func remove() {
        guard parent != nil else {
            return
        }

        willMove(toParentViewController: nil)
        removeFromParentViewController()
        view.removeFromSuperview()
    }

    func removeFromOtherChild(_ child: UIViewController) {
        child.willMove(toParentViewController: nil)
        child.removeFromParentViewController()
        child.view.removeFromSuperview()
    }
}
