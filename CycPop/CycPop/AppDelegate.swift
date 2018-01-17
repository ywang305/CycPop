//
//  AppDelegate.swift
//  CycPop
//
//  Created by 布莱德 王 on 2017/4/2.
//  Copyright © 2017年 Syracuse University. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let itemStore = ItemStore(demo: false)
    let bubbleAnimationHandler = BubbleAnimation()


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //let itemStore = ItemStore(demo: true)
        
        let tbController = window!.rootViewController as! UITabBarController
        
        let timeController = tbController.viewControllers![1] as! TimeViewController
        timeController.itemStore = itemStore
        timeController.bubbleAnimationHandler = bubbleAnimationHandler
        
        let mapController = tbController.viewControllers![2] as! MapViewController
        mapController.itemStore = itemStore
        mapController.bubbleAnimationHandler = bubbleAnimationHandler
        
        let itemsController = tbController.viewControllers![3] as! ItemsViewController
        itemsController.itemStore = itemStore
        
        let homeController = tbController.viewControllers![0] as! HomeViewController
        homeController.itemStore = itemStore
        homeController.itemsViewController = itemsController  // to enable to insert new item from homeController
        homeController.bubbleAnimationHandler = bubbleAnimationHandler
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        let success = itemStore.saveChanges()
        if success {
            print( " items saved ")
        } else {
            print( " save failed ")
        }
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        let success = itemStore.saveChanges()
        if success {
            print( " items saved ")
        } else {
            print( " save failed ")
        }
    }


}

