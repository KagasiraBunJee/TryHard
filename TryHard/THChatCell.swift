//
//  THChatCell.swift
//  TryHard
//
//  Created by Sergey on 5/20/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

import UIKit

class THChatCell: UITableViewCell {

    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var serverMessage: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func setMessage(sender:String, text:NSString, isServer:Bool = false) {
        if isServer {
            author.hidden = true
            author.text = ""
            message.hidden = true
            message.text = ""
            serverMessage.hidden = false
            serverMessage.text = text as String
        } else {
            author.hidden = false
            author.text = sender
            message.hidden = false
            message.text = text as String
            serverMessage.hidden = true
            serverMessage.text = ""
        }
    }
}
