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

extension UIImage {
    
    func drawRects(rects:[CGRect], color:UIColor) -> UIImage {
        
        var newImage:UIImage!
        
        let size = CGSize(width: CGImageGetWidth(self.CGImage),
                          height: CGImageGetHeight(self.CGImage))
        
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        let ctx = UIGraphicsGetCurrentContext()
        self.drawInRect(CGRectMake(0, 0, self.size.width, self.size.height))
        
        for rect in rects {
            CGContextSaveGState(ctx)
            
            CGContextSetStrokeColorWithColor(ctx, color.CGColor)
            CGContextSetLineWidth(ctx, 2.0)
            CGContextStrokeRect(ctx, rect)
            
            CGContextRestoreGState(ctx)
            
            newImage = UIGraphicsGetImageFromCurrentImageContext()
            
        }
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}

extension CIContext {
    func createCGImage_(image:CIImage, fromRect:CGRect) -> CGImage {
        let width = Int(fromRect.width)
        let height = Int(fromRect.height)
        
        let rawData =  UnsafeMutablePointer<UInt8>.alloc(width * height * 4)
        render(image, toBitmap: rawData, rowBytes: width * 4, bounds: fromRect, format: kCIFormatRGBA8, colorSpace: CGColorSpaceCreateDeviceRGB())
        let dataProvider = CGDataProviderCreateWithData(nil, rawData, height * width * 4) {info, data, size in UnsafeMutablePointer<UInt8>(data).dealloc(size)}
        return CGImageCreate(width, height, 8, 32, width * 4, CGColorSpaceCreateDeviceRGB(), CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue), dataProvider, nil, false, .RenderingIntentDefault)!
    }
}