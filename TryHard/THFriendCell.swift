//
//  THFriendCell.swift
//  TryHard
//
//  Created by Sergei on 7/22/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

import UIKit
import FoldingCell

class THFriendCell: FoldingCell {
    
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var buddyName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    func setBuddyStatus(status:BUDDY_STATUS) {
        
        switch status {
        case .UNKNOWN:
            statusView.backgroundColor = UIColor.darkGrayColor()
        case .OFFLINE:
            statusView.backgroundColor = UIColor.redColor()
        case .ONLINE:
            statusView.backgroundColor = UIColor.greenColor()
        }
        
    }
    
    override func animationDuration(itemIndex:NSInteger, type:AnimationType)-> NSTimeInterval {
        
        // durations count equal it itemCount
        let durations = [0.33, 0.26, 0.26] // timing animation for each view
        return durations[itemIndex]
    }
}
