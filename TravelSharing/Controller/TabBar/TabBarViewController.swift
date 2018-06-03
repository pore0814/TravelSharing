//
//  TabBarViewController.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/4/26.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit

enum TabBar {

    case trackLocation

    case schedule

    case profile
    
    case friend

    func controller() -> UIViewController {
        switch self {
        case .trackLocation:
            return UIStoryboard.trackLocationStoryboard().instantiateInitialViewController()!
        case .schedule:
            return UIStoryboard.scheduleStoryboard().instantiateInitialViewController()!
        case .profile:
            return UIStoryboard.profileStoryboard().instantiateInitialViewController()!
        case .friend:
            return
           UIStoryboard.friendsStoryboard().instantiateInitialViewController()!
        
        }
    }

    func image() -> UIImage {

        switch self {
        case .trackLocation:
            
                return #imageLiteral(resourceName: "foot")
            
        case .schedule:
            
                return #imageLiteral(resourceName: "calendar1")
            
        case .profile:
            
                return #imageLiteral(resourceName: "user")
            
        case .friend:
            
                return #imageLiteral(resourceName: "foot")
        }
    }

    func selectedImage() -> UIImage {

        switch self {

        case .trackLocation:

            return #imageLiteral(resourceName: "human-foot-prints").withRenderingMode(.alwaysTemplate)

        case .schedule:

            return #imageLiteral(resourceName: "calendar2").withRenderingMode(.alwaysTemplate)

        case .profile:

            return #imageLiteral(resourceName: "user1").withRenderingMode(.alwaysTemplate)
            
        case .friend:
            
            return #imageLiteral(resourceName: "human-foot-prints").withRenderingMode(.alwaysTemplate)
        }
    }
}
func changeColor() {

}

class TabBarViewController: UITabBarController {

   // let tabs: [TabBar] = [.trackLocation, .schedule, .profile]
    let tabs: [TabBar] = [.schedule, .profile ,.friend]
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTab()
    }

    private func setupTab() {
       //tabBar.barTintColor = UIColor(displayP3Red: 38/255, green: 196/255, blue: 133/255, alpha: 1)

         tabBar.tintColor = TSColor.tabBarTintColor.color()

        var controllers: [UIViewController] = []

        for tab in tabs {

            let controller = tab.controller()

            let item = UITabBarItem(
                title: nil,
                image: tab.image(),
                selectedImage: tab.selectedImage()
            )

            item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

            controller.tabBarItem = item

            controllers.append(controller)
        }

        setViewControllers(controllers, animated: false)

    }

}
