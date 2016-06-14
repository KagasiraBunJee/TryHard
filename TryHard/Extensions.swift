//
//  Extensions.swift
//  TryHard
//
//  Created by Sergey on 5/20/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
        
    func showAlert(withMessage message: String?) {
        showAlert(withMessage: message, onClose: nil)
    }
    
    func showAlert(withMessage message: String?, onClose: (() -> Void)?) {
        
        dispatch_async(dispatch_get_main_queue()) {
            let alertView = UIAlertController(title: "MapaMagic", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: {(action) -> Void in
                onClose?()
                alertView.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.presentViewController(alertView, animated: true, completion: nil)
        }
    }
    
    func showAlertDialog(withMessage message: String?, onAccept: (() -> Void)?) {
        showAlertDialog(withMessage: message, onAccept: onAccept, onCancel: nil)
    }
    
    func showAlertDialog(withMessage message: String?, onAccept: (() -> Void)?, onCancel: (() -> Void)?) {
        dispatch_async(dispatch_get_main_queue()) {
            let alertView = UIAlertController(title: "MapaMagic", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
                onAccept?()
            }))
            if onCancel != nil {
                alertView.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
                    onCancel?()
                    alertView.dismissViewControllerAnimated(true, completion: nil)
                }))
            }
            self.presentViewController(alertView, animated: true, completion: nil)
        }
    }
}