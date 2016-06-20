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
    
    var url = NSURL(string: "https://upload.wikimedia.org/wikipedia/commons/e/ee/Emoticons_Puck_1881_with_Text.png")!
    
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
//        self.imageBefore.image = image.blurredImage()
        let images = image.textDetect()
        
        if images != nil {
            self.imageBefore.image = images
        }
        
    }
    
}
