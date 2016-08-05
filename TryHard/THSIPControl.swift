//
//  THSIPControl.swift
//  TryHard
//
//  Created by Sergei on 7/22/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

import UIKit
import AFDropdownNotification

class THSIPControl: UIViewController, PJSIPDelegate, PJSIPBuddyDelegate, AFDropdownNotificationDelegate {

    var sipManager:THPJSipManager!
    var notif:AFDropdownNotification!
    
    @IBOutlet weak var contact: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sipManager = THPJSipManager.sharedManager()
        sipManager.delegate = self
        sipManager.buddyDelegate = self
        
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil))
    }
    
    @IBAction func callAction(sender: AnyObject) {
        sipManager.callTo(contact.text!, withVideo: true, conferenceID: 0)
    }
    
    @IBAction func answerAction(sender: AnyObject) {
        sipManager.answer(0, withVideo: true)
    }
    
    @IBAction func setOnlineAction(sender: AnyObject) {
        sipManager.setAccountPresence(0, online: true)
    }
    
    @IBAction func setOfflineAction(sender: AnyObject) {
        sipManager.setAccountPresence(0, online: false)
    }
    
    func pjsip_onFriendRequestReceived(buddyId: Int32, buddyURI: String!, reason: String!, msg: String!) {
        sipManager.addBuddy(buddyURI)
        
        THNotificationHelper.showNotification("Somebody has added you to friends", title: "Friends")
    }
    
    //MARK:- AFDropdownNotificationDelegate
    func dropdownNotificationTopButtonTapped() {
        self.notif.dismissWithGravityAnimation(true)
    }
    
    func dropdownNotificationBottomButtonTapped() {
        self.sipManager.busy(0, withMessage: "")
        self.notif.dismissWithGravityAnimation(true)
    }
    
    //MARK:- THPJSipManagerDelegate
    func pjsip_onIncomingCall(callId: Int32, callInfo: PJSIPCallInfo!) {
        print("call incoming")
//        THNotificationHelper.showNotification("Someone is calling you", title: "PJSIP")
//        notif = AFDropdownNotification()
//        notif.titleText = "Call incoming"
//        notif.subtitleText = "\(callInfo.remoteInfo) is calling you"
//        notif.topButtonText = "Accept"
//        notif.bottomButtonText = "Busy"
//        notif.dismissOnTap = true
//        notif.notificationDelegate = self
//        
//        notif.presentInView(self.view, withGravityAnimation: true)
    }
    
    func pjsip_onCallDidConfirm(callId: Int32, callInfo: PJSIPCallInfo!) {
        print("call confirmed")
    }
}
