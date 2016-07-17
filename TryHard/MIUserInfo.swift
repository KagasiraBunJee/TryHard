//
//  MIUserInfo.swift
//  TryHard
//
//  Created by Sergei on 6/15/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

import UIKit

class MIUserInfo {

    var uid:UInt32!
    var gender:UInt8 = 1
    var age:UInt8!
    var height:UInt8!
    var weight:UInt8!
    var alias = ""
    var type:UInt8!
    
    private var deviceAddress = "C8:0F:10:11:C4:84"
    
    class func example() -> MIUserInfo {
        
        let userInfo = MIUserInfo()
        
        userInfo.uid = 1928372211
        userInfo.gender = 1
        userInfo.age = 16
        userInfo.height = 150
        userInfo.weight = 150
        userInfo.type = 0
        userInfo.alias = "\(userInfo.uid)"
        
        return userInfo
    }
    
    func encode() {
        
    }
}
