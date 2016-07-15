//
//  THImageSelector.swift
//  TryHard
//
//  Created by Sergey on 6/16/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

import UIKit
//import HanabiCollectionViewLayout
import SDWebImage

class THImageSelector: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var imageSelected: ((image:UIImage) -> ())?
    
    let imagesUrls = [
        "http://multilingualtypesetting.co.uk/blog/images/chinese-typesetting_english-original.png",
        "http://i.stack.imgur.com/w0euX.png",
        "http://universitypublishingonline.org/content/978/11/3952/429/2/9781139524292prf3_abstract_CBO.jpg",
        "http://i1.ytimg.com/vi/OzZb1tthfEI/maxresdefault.jpg",
        "http://www.stav.org.il/karmeli/pages/EnglishSample.png",
        "http://i.stack.imgur.com/XuJOl.png"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let layout = HanabiCollectionViewLayout()
        
//        layout.standartHeight = 100
//        layout.focusedHeight = 280
//        layout.dragOffset = 180
        
//        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    //MARK:- IBActions
    @IBAction func selectImage(sender: AnyObject) {
    }
    
    @IBAction func cancel(sender: AnyObject) {
    }
    
    //MARK:- UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesUrls.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("imageCell", forIndexPath: indexPath) as! ImageCell
        
        let urlString = NSURL(string: imagesUrls[indexPath.row])!
        
        SDWebImageManager.sharedManager().downloadImageWithURL(urlString, options: .ContinueInBackground, progress: nil) { (image, error, cacheType, true, url) in
            
            cell.imageCell.image = image
        }
        
        return cell
    }
    
    //MARK:- UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ImageCell
        let image = cell.imageCell.image
        
        imageSelected?(image: image!)
        self.navigationController?.popViewControllerAnimated(true)
    }
}
