//
//  THPJSIP.swift
//  TryHard
//
//  Created by Sergey on 7/14/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

import UIKit

class THPJSIP: UIViewController, THPJSipManagerDelegate {
    
    @IBOutlet weak var nickname: UITextField!
    @IBOutlet weak var friend: UITextField!
    
    lazy var serverDomain = "192.168.0.105"
    
    var sipManager:THPJSipManager!
    var currentCall:Int32?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sipManager = THPJSipManager.sharedManager()
        sipManager.delegate = self
    }
    
    @IBAction func registerAction(sender: AnyObject) {
        sipManager.registerUser(nickname.text!, sipDomain: serverDomain)
    }
    
    @IBAction func makeCall(sender: AnyObject) {
        sipManager.callTo(friend.text!)
    }
    
    @IBAction func answerCall(sender: AnyObject) {
        if let call = currentCall {
            sipManager.answer(call)
        }
    }
    
    @IBAction func hangUP(sender: AnyObject) {
        if let call = currentCall {
            sipManager.hangUp(call)
        }
    }
    
    @IBAction func holdCall(sender: AnyObject) {
        if let call = currentCall {
            sipManager.holdCall(call)
        }
    }
    
    @IBAction func unholdCall(sender: AnyObject) {
        if let call = currentCall {
            sipManager.unholdCall(call)
        }
    }
    
    //MARK:- THPJSipManagerDelegate
    func sipOnIncomingCall(callId: Int32, callInfo: PJSIPCallInfo!) {
        currentCall = callId
        print("incoming call")
    }
}
