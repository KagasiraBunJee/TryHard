//
//  THSIPLoginVC.swift
//  TryHard
//
//  Created by Sergei on 7/22/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

import UIKit

class THSIPLoginVC: UIViewController, PJSIPRegisterDelegate {

    @IBOutlet weak var usernameTF: THTextField!
    @IBOutlet weak var passwordTF: THTextField!
    
    var onSuccess:(() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func login(sender: AnyObject) {
        
        if !usernameTF.text!.isEmpty && !passwordTF.text!.isEmpty {
            let sipManager = THPJSipManager.sharedManager()
//            sipManager.outboundProxy = "sip.linphone.org"
//            sipManager.outboundProxyPort = "5060"
            sipManager.regDelegate = self
            sipManager.start()
            
            let credInfo = PJSIPCredention()
            credInfo.username = usernameTF.text!
            credInfo.nickname = usernameTF.text!
            credInfo.address = "sip.linphone.org"
            credInfo.dataType = .PLAIN_PASSWORD
            credInfo.data = passwordTF.text!
            credInfo.realm = "sip.linphone.org"
            credInfo.proxy = "sip.linphone.org"
            credInfo.scheme = "digest"
            
            sipManager.registerUser(credInfo, userInfo: nil)
        }
        
    }
    
    //MARK:- PJSIPRegisterDelegate
    
    func pjsip_onAccountRegistered(accId: Int32) {
        onSuccess?()
        THPJSipManager.sharedManager().regDelegate = nil
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
