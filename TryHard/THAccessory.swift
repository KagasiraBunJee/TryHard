//
//  THAccessory.swift
//  TryHard
//
//  Created by Sergey on 6/14/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

import UIKit
import ExternalAccessory

class THAccessory: UIViewController, EAAccessoryDelegate {

    var accessoryManager:EAAccessoryManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        accessoryManager = EAAccessoryManager.sharedAccessoryManager()
    }

    @IBAction func showAccessories(sender: AnyObject) {
        accessoryManager.showBluetoothAccessoryPickerWithNameFilter(nil) { (error) in
            print(error)
        }
    }
}
