//
//  UIViewController+storyboardLoad.swift
//  FashionSwapp
//
//  Created by chublix on 9/6/15.
//  Copyright (c) 2015 eKreative. All rights reserved.
//

import UIKit
import Foundation

enum FOStoryboard : String {
    case Main
    case Bluetooth
    case Accessory
    case Tesseract
    case ImageSelector
    case ImageProcessing
    case VideoProcessing
}

class VCLoader<VC: UIViewController> {
	
	class func load(storyboardName storyboard: String!) -> VC {
		let className = NSStringFromClass(VC.self).componentsSeparatedByString(".").last!
		return VCLoader<VC>.load(storyboardName: storyboard, inStoryboardID: className)
	}
	
	class func load(storyboardName storyboard: String!, inStoryboardID: String!) -> VC {
		let storyboard = UIStoryboard(name: storyboard, bundle: NSBundle.mainBundle())
		return storyboard.instantiateViewControllerWithIdentifier(inStoryboardID) as! VC
	}
	
}

extension VCLoader {
    
	class func load(storyboardId storyboard: FOStoryboard) -> VC {
		return VCLoader<VC>.load(storyboardName: storyboard.rawValue)
	}
	
	class func load(storyboardId storyboard: FOStoryboard, inStoryboardID: String!) -> VC {
		let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: NSBundle.mainBundle())
		return storyboard.instantiateViewControllerWithIdentifier(inStoryboardID) as! VC
	}
    
    class func loadInitial(storyboardId storyboard: FOStoryboard) -> VC {
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: NSBundle.mainBundle())
        return storyboard.instantiateInitialViewController() as! VC
    }
	
}
