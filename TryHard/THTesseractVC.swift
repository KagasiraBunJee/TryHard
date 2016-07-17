//
//  THTesseractVC.swift
//  TryHard
//
//  Created by Sergey on 6/16/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

import UIKit
import TesseractOCR
import SDWebImage

class THTesseractVC: UIViewController, G8TesseractDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var tesseractProgress: UIProgressView!
    
    let textURL = NSURL(string: "http://universitypublishingonline.org/content/978/11/3952/429/2/9781139524292prf3_abstract_CBO.jpg")!
    var tesseract:G8Tesseract!
    
    var textImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        progressBar.setProgress(0, animated: false)
        tesseractProgress.setProgress(0, animated: false)
        tesseract = G8Tesseract(language: "eng", engineMode: .TesseractCubeCombined)
        
        tesseract.delegate = self
        
    }

    //IBActions
    @IBAction func recognize(sender: AnyObject) {
        
        tesseractProgress.setProgress(0, animated: false)
        self.tesseract.image = self.textImage.g8_blackAndWhite()
        
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.tesseract.recognize()
        });

    }
    
    @IBAction func download(sender: AnyObject) {
        
        SDWebImageManager.sharedManager().downloadImageWithURL(textURL, options: .RefreshCached, progress: { (current, overall) in
            
            if overall > 0 {
                let progressValue = Float(current)/Float(overall)
                self.progressBar.setProgress(progressValue, animated: true)
            }
            
        }) { (image, error, cacheType, complete, url) in
            
            if complete {
                let alertView = UIAlertController(title: "Tesseract", message: "Image is downloaded", preferredStyle: .Alert)
                alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) in
                    alertView.dismissViewControllerAnimated(true, completion: nil)
                }))
                self.presentViewController(alertView, animated: true, completion: nil)
                
                self.textImage = image
            }
        }
    }
    
    @IBAction func showRecognizedText(sender: AnyObject) {
        self.textView.text = tesseract.recognizedText
    }
    
    @IBAction func selectText(sender: AnyObject) {
        let vc = VCLoader<THImageSelector>.load(storyboardId: .ImageSelector, inStoryboardID: "THImageSelector")
        
        vc.imageSelected = { image in
            self.textImage = image
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- G8TesseractDelegate
    func progressImageRecognitionForTesseract(tesseract: G8Tesseract!) {
        
        dispatch_async( dispatch_get_main_queue(), {
            self.tesseractProgress.setProgress(Float(tesseract.progress), animated: true)
        });
    }
}
