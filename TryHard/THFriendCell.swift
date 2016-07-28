//
//  THFriendCell.swift
//  TryHard
//
//  Created by Sergei on 7/22/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

import UIKit

class THFriendCell: UITableViewCell {

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
}
