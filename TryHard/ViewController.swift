//
//  ViewController.swift
//  TryHard
//
//  Created by Sergey on 3/18/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var projects = [TryProject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        projects = [
            TryProject(title: "SwiftCharts", projectInfo: "", vc: VCLoader<THSwiftChartsVC>.load(storyboardId: .Main, inStoryboardID: "THSwiftChartsVC")),
            TryProject(title: "QExpand", projectInfo: "", vc: VCLoader<QExpandVC>.load(storyboardId: .Main, inStoryboardID: "QExpandVC")),
            TryProject(title: "Blur", projectInfo: "", vc: VCLoader<THBlurVC>.load(storyboardId: .Main, inStoryboardID: "THBlurVC")),
            TryProject(title: "SocketChat", projectInfo: "", vc: VCLoader<THSocketVC>.load(storyboardId: .Main, inStoryboardID: "THSocketVC")),
            TryProject(title: "PrivateBT", projectInfo: "", vc: VCLoader<THPrivateBT>.load(storyboardId: .Main, inStoryboardID: "THPrivateBT")),
            TryProject(title: "PublicBT", projectInfo: "", vc: VCLoader<THPublicBT>.load(storyboardId: .Bluetooth, inStoryboardID: "THPublicBT")),
//            TryProject(title: "Accessory", projectInfo: "", vc: VCLoader<THAccessory>.load(storyboardId: .Accessory, inStoryboardID: "THAccessory")),
            TryProject(title: "Text recognition", projectInfo: "Tesseract library", vc: VCLoader<THTesseractVC>.load(storyboardId: .Tesseract, inStoryboardID: "THTesseractVC")),
            TryProject(title: "ImageProcessing", projectInfo: "", vc: VCLoader<THImageProcessingVC>.load(storyboardId: .ImageProcessing, inStoryboardID: "THImageProcessingVC")),
            TryProject(title: "VideoProcessing", projectInfo: "", vc: VCLoader<THVideoController>.load(storyboardId: .VideoProcessing, inStoryboardID: "THVideoController")),
            TryProject(title: "AudioCommands", projectInfo: "", vc: VCLoader<THCommandVC>.load(storyboardId: .Audio, inStoryboardID: "THCommandVC")),
//            TryProject(title: "PJSIP", projectInfo: "", vc: VCLoader<THPJSIP>.load(storyboardId: .SIP, inStoryboardID: "THPJSIP"))
            TryProject(title: "PJSIP", projectInfo: "", vc: VCLoader<THSIPLoginVC>.load(storyboardId: .SIP, inStoryboardID: "THSIPLoginVC"), present: true)
        ]
        
        tableView.tableFooterView = UIView()
    }
    
    //MARK:- UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("projectCell")!
        let project = projects[indexPath.row]
        
        cell.textLabel!.text = project.title
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let project = projects[indexPath.row]
        
        if project.present {
            if let vc = project.viewController as? THSIPLoginVC {
                
                let go = {
                    let vc = VCLoader<UITabBarController>.load(storyboardId: .SIP, inStoryboardID: "sipControl")
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                if THPJSipManager.sharedManager().started() {
                    go()
                } else {
                    vc.onSuccess = {
                        let vc = VCLoader<UITabBarController>.load(storyboardId: .SIP, inStoryboardID: "sipControl")
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    self.navigationController?.presentViewController(project.viewController!, animated: true, completion: nil)
                }
            }
        } else {
            self.navigationController?.pushViewController(project.viewController!, animated: true)
        }
    }
}

