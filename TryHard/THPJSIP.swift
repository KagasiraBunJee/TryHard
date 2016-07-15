//
//  THPJSIP.swift
//  TryHard
//
//  Created by Sergey on 7/14/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

import UIKit

class THPJSIP: UIViewController {
    
    @IBOutlet weak var nickname: UITextField!
    @IBOutlet weak var friend: UITextField!
    
    var sipManager:THPJSipManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sipManager = THPJSipManager.sharedManager()
        
    }
    
    @IBAction func registerAction(sender: AnyObject) {
        sipManager.registerUser(nickname.text!, sipDomain: "10.0.1.68")
    }
    
    @IBAction func makeCall(sender: AnyObject) {
        sipManager.callTo(friend.text!)
    }
}
