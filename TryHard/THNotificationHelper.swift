//
//  THNotificationHelper.swift
//  TryHard
//
//  Created by Sergey on 7/29/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

import UIKit
import Foundation

class THNotificationHelper: NSObject {

    class func showNotification(message:String, title:String, badge:Int = 0) {
        
        let notification = UILocalNotification()
        notification.fireDate = NSDate(timeIntervalSinceNow: 1)
        notification.alertBody = message
        notification.alertTitle = title
        notification.applicationIconBadgeNumber = badge
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
}
