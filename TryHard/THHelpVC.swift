//
//  THHelpVC.swift
//  TryHard
//
//  Created by Sergey on 6/20/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

import UIKit

class THHelpVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = image
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
//            
//            self.imageView.image = self.image.textDetectBetterV2()
//        })
    }

    
}
