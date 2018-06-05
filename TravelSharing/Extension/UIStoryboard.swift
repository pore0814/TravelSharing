//
//  UIStoryboard.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/4/26.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit

extension UIStoryboard {

    static func logInStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Login", bundle: nil)
    }

    static func registerStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Register", bundle: nil)
    }

    static func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }

    static func scheduleStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Schedule", bundle: nil)
    }

    static func profileStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Profile", bundle: nil)
    }

    static func trackLocationStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "TrackLocation", bundle: nil)
    }

    static func friendsStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "FriendsList", bundle: nil)
    }
    
    static func guildlineStoryboard() -> UIStoryboard{
        return UIStoryboard(name: "GuildLine", bundle: nil)
    }
}
