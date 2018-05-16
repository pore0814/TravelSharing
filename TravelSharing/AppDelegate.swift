//
//  AppDelegate.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/4/26.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?
    let apiKey = "AIzaSyApfLr_yp72naCXwEQyuwwNc6JwiE8Cj1I"

     static let shared = UIApplication.shared.delegate as? AppDelegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        GMSServices.provideAPIKey(apiKey)
        GMSPlacesClient.provideAPIKey(apiKey)

//跳轉到MainViewController()
        if UserManager.shared.getFireBaseUID() != nil {
            switchMainViewController()
        } else {
             window?.rootViewController = UIStoryboard.logInStoryboard().instantiateInitialViewController()
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //換頁_主頁面
    func switchMainViewController() {
        let tabBar = TabBarViewController()
              window?.rootViewController = tabBar
    }

    func switchToLoginViewController() {
        guard  let loginPage = UIStoryboard.logInStoryboard().instantiateInitialViewController() else {return}
        window?.rootViewController = loginPage

    }
    func switchScheduleViewController() {
        guard  let schedulePage = UIStoryboard.scheduleStoryboard().instantiateInitialViewController() else {return}
        window?.rootViewController = schedulePage

    }

}
