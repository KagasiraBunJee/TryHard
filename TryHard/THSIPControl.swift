//
//  THSIPControl.swift
//  TryHard
//
//  Created by Sergei on 7/22/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

import UIKit

class THSIPControl: UIViewController, PJSIPDelegate, PJSIPBuddyDelegate {

    var sipManager:THPJSipManager!
    @IBOutlet weak var contact: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sipManager = THPJSipManager.sharedManager()
        sipManager.delegate = self
        sipManager.buddyDelegate = self
    }
    
    @IBAction func callAction(sender: AnyObject) {
        sipManager.callTo(contact.text!, withVideo: false)
    }
    
    @IBAction func answerAction(sender: AnyObject) {
        sipManager.answer(0, withVideo: false)
    }
    
    @IBAction func setOnlineAction(sender: AnyObject) {
        sipManager.setAccountPresence(0, online: true)
    }
    
    @IBAction func setOfflineAction(sender: AnyObject) {
        sipManager.setAccountPresence(0, online: false)
    }
    
    //MARK:- THPJSipManagerDelegate
    func pjsip_onIncomingCall(callId: Int32, callInfo: PJSIPCallInfo!) {
        print("call incoming")
    }
    
    func pjsip_onFriendRequestReceived(buddyId: Int32, buddyURI: String!, reason: String!, msg: String!) {
        sipManager.addBuddy(buddyURI)
        
        THNotificationHelper.showNotification("Somebody has added you to friends", title: "Friends")
    }
}
