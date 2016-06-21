//
//  THImageProcessingVC.swift
//  TryHard
//
//  Created by Sergey on 6/17/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

import UIKit
import SDWebImage

class THImageProcessingVC: UIViewController {

    @IBOutlet weak var imageBefore: UIImageView!
    
    private var image:UIImage?
    
    var url = NSURL(string: "https://onepagelove.com/wp-content/uploads/2016/03/opl-big-5.jpg")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SDWebImageManager.sharedManager().downloadImageWithURL(url, options: .RefreshCached, progress: nil) { (image, error, cacheType, complete, url) in
            
            if complete {
                
                self.image = image
                
            }
        }
    }
    
    //MARK:- IBAction
    @IBAction func downloadAction(sender: AnyObject) {
        imageBefore.image = image
    }
    
    @IBAction func processAction(sender: AnyObject) {
        
        let image = self.imageBefore.image!.copy() as! UIImage
        
//        let bounds = (image.textBoundsV2() as! [NSValue]).map { (value) -> CGRect in
//            return value.CGRectValue()
//        }
//        
//        let rectedImage = image.drawRects(bounds, color: UIColor.redColor())
        
        imageBefore.image = image.textDetectBetterV2()
        
        print(image.textBoundsV2())
        
    }
    
}
