//
//  THPJSIP.swift
//  TryHard
//
//  Created by Sergey on 7/14/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

import UIKit

class THPJSIP: UIViewController, THPJSipManagerDelegate {
    
    @IBOutlet weak var nickname: THTextField!
    @IBOutlet weak var friend: THTextField!
    @IBOutlet weak var videoView: UIView!
    
    lazy var serverDomain = "10.0.1.68"
    
    var sipManager:THPJSipManager!
    var currentCall:Int32?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sipManager = THPJSipManager.sharedManager()
        sipManager.delegate = self
        sipManager.videoView = videoView
    }
    
    @IBAction func registerAction(sender: AnyObject) {
        let dict = [
            "userName" : "test",
            "userLastName" : "testtest"
        ]
        let data = NSKeyedArchiver.archivedDataWithRootObject(dict)
        
        sipManager.registerUser(nickname.text!, sipDomain: serverDomain, userInfo: UnsafeMutablePointer<Void>(data.bytes))
    }
    
    @IBAction func makeCall(sender: AnyObject) {
        sipManager.callTo(friend.text!, withVideo: true)
    }
    
    @IBAction func answerCall(sender: AnyObject) {
        if let call = currentCall {
            sipManager.answer(call, withVideo: true)
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
