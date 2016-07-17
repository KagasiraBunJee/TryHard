//
//  MIServiceManager.swift
//  TryHard
//
//  Created by Sergei on 6/15/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

import UIKit
import CoreBluetooth

class MIServiceManager: NSObject {

    private var characteristics = [CBCharacteristic]()
    
    static func sharedManager() -> MIServiceManager {
        return MIServiceManager()
    }
    
    func add(ch:CBCharacteristic) {
        
        if exists(ch) {
            characteristics.removeAtIndex(characteristics.indexOf(ch)!)
        }
        
        characteristics.append(ch)
    }
    
    func exists(ch:CBCharacteristic) -> Bool {
        
        if characteristics.contains(ch) {
            return true
        }
        
        return false
    }
    
    func remove(ch:CBCharacteristic) {
        if exists(ch) {
            characteristics.removeAtIndex(characteristics.indexOf(ch)!)
        }
    }
    
    func get(chType:MICharacteristic) -> CBCharacteristic? {
        
        var characteristic:CBCharacteristic?
        for ch in characteristics {
            if MICharacteristic(rawValue: ch.UUID.UUIDString)! == chType {
                characteristic = ch
                break
            }
        }
        
        return characteristic
    }
}
