//
//  THRoundedView.swift
//  TryHard
//
//  Created by Sergey on 5/31/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

import UIKit

class THRoundedView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
}
