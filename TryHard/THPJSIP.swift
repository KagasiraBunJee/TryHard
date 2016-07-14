//
//  THPJSIP.swift
//  TryHard
//
//  Created by Sergey on 7/14/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

import UIKit

class THPJSIP: UIViewController {

    var status:pj_status_t!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        status = pjsua_create()
        
        if status != PJ_SUCCESS.rawValue {
            
        }
        
        // Do any additional setup after loading the view.
    }

}
