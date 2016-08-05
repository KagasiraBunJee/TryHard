//
//  AppDelegate.swift
//  TryHard
//
//  Created by Sergey on 3/18/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

import UIKit
import CoreData
import PushKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PJSIPDelegate {

    var window: UIWindow?
    var manager:THPJSipManager!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
//        THImageFilter.config()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//        manager = THPJSipManager.sharedManager()
        
//        manager.delegate = self

    }

    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        
        application.setKeepAliveTimeout(600) {
            self.performSelectorOnMainThread(#selector(self.keepAlive), withObject: nil, waitUntilDone: true)
        }
    }

    func keepAlive() {
        THPJSipManager.sharedManager().keepAlive()
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }

    //MARK:- PJSIPDelegate
    func pjsip_onIncomingCall(callId: Int32, callInfo: PJSIPCallInfo!) {
        THNotificationHelper.showNotification("Someone is calling you", title: "PJSIP")
    }
}

