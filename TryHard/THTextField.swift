//
//  THTextField.swift
//  TryHard
//
//  Created by Sergey on 5/27/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

import UIKit

class THTextField: UITextField {

    var onDone: (() -> ())?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let keyboardToolBar:UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        keyboardToolBar.barStyle = UIBarStyle.Default
        let toolBarItem: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        let doneItem: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(THTextField.onDoneTouchUp))
        keyboardToolBar.items = [
            toolBarItem,
            doneItem
        ]
        keyboardToolBar.sizeToFit()
        self.inputAccessoryView = keyboardToolBar
    }
    
    func onDoneTouchUp() {
        onDone?()
        self.resignFirstResponder()
    }
    
}
