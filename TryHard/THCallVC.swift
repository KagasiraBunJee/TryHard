//
//  THCallVC.swift
//  TryHard
//
//  Created by Sergei on 7/22/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

import UIKit
import iCarousel

enum CallMemberType {
    case MEMBER
    case CALLER
}

class THCallVC: UIViewController, iCarouselDelegate, iCarouselDataSource, PJSIPDelegate {

    @IBOutlet weak var contactCarousel: iCarousel!
    
    lazy var sipManager = THPJSipManager.sharedManager()
    var currentCall:Int32?
    var participants = []
    var memberType:CallMemberType = .MEMBER
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactCarousel.delegate = self
        contactCarousel.dataSource = self
        contactCarousel.type = .Linear
        contactCarousel.scrollOffset = 50
        contactCarousel.scrollSpeed = 0.3
        contactCarousel.bounces = false
        contactCarousel.currentItemIndex = 0
        
        sipManager.delegate = self
    }
    
    @IBAction func hangUpAction(sender: AnyObject) {
        
        if let currentCall = currentCall {
            sipManager.hangUp(currentCall, withMessage: nil)
        }
    }
    
    @IBAction func addParticipant(sender: AnyObject) {
        
    }
    
    //MARK:- iCarouselDataSource
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        return participants.count
    }
    
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        
        var image:UIImageView!
        
        if view == nil {
            
            let rect = CGRectMake(0, 0, self.view.frame.width, self.view.frame.width)
            let insetRect = CGRectInset(rect, 20, 20)
            
            image = UIImageView()
            image.frame = insetRect
            image.image = UIImage(named: "contact_icon")
            image.contentMode = .ScaleAspectFit
            
        } else {
            image = view as! UIImageView
        }
        
        return image
    }
    
    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        switch option {
        case .VisibleItems:
            return CGFloat(participants.count)
        case .Spacing:
            return 1.2
        default:
            return value
        }
    }
    
    //MARK:- PJSIPDelegate
}
