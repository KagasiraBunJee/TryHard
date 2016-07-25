//
//  THSIPControl.swift
//  TryHard
//
//  Created by Sergei on 7/22/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

import UIKit

class THSIPControl: UIViewController, THPJSipManagerDelegate {

    var sipManager:THPJSipManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sipManager = THPJSipManager.sharedManager()
        sipManager.delegate = self
    }
    
    //MARK:- THPJSipManagerDelegate
    func pjsip_onIncomingCall(callId: Int32, callInfo: PJSIPCallInfo!) {
        
    }
    
    func pjsip_onFriendRequestReceived(buddyId: Int32, buddyURI: String!, reason: String!, msg: String!) {
        print("user \(buddyURI) wants to add you to friends")
    }
}
