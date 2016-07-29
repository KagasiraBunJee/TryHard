//
//  THFriendListVC.swift
//  TryHard
//
//  Created by Sergei on 7/22/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

import UIKit
import FoldingCell

class THFriendListVC: UIViewController, UITableViewDataSource, UITableViewDelegate, PJSIPBuddyDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchFriend: THTextField!
    
    var sipManager:THPJSipManager!
    var buddies:[PJSIPBuddy]!
    
    let kCloseCellHeight: CGFloat = 50 // equal or greater foregroundView height
    let kOpenCellHeight: CGFloat = 200 // equal or greater containerView height
    
    var cellHeights = [CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sipManager = THPJSipManager.sharedManager()
        sipManager.buddyDelegate = self
        
        buddies = sipManager.buddyList()
        
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        searchFriend.onDone = {
            
            self.sipManager.addBuddy(self.searchFriend.text!)
        }
        
        refresh()
    }

    func refresh() {
        
        cellHeights.removeAll(keepCapacity: false)
        
        for _ in 0...buddies.count {
            cellHeights.append(kCloseCellHeight)
        }
    }
    
    //MARK:- UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buddies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let buddy = buddies[indexPath.row];
        let cell = tableView.dequeueReusableCellWithIdentifier("friendCell") as! THFriendCell
        
        cell.buddyName.text = buddy.buddyLogin
        cell.setBuddyStatus(buddy.buddyStatus)
        
        return cell
    }
    
    //MARK:- UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! THFriendCell
        
        var duration = 0.0
        if cellHeights[indexPath.row] == kCloseCellHeight { // open cell
            cellHeights[indexPath.row] = kOpenCellHeight
            cell.selectedAnimation(true, animated: true, completion: nil)
            duration = 0.5
        } else {// close cell
            cellHeights[indexPath.row] = kCloseCellHeight
            cell.selectedAnimation(false, animated: true, completion: nil)
            duration = 1.1
        }
        
        UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if cell is THFriendCell {
            let foldingCell = cell as! THFriendCell
            
            if cellHeights[indexPath.row] == kCloseCellHeight {
                foldingCell.selectedAnimation(false, animated: false, completion:nil)
            } else {
                foldingCell.selectedAnimation(true, animated: false, completion: nil)
            }
        }
    }
    
    //MARK:- PJSIPBuddyDelegate
    func pjsip_onBuddyStateChanged(buddyId: Int32, buddy: PJSIPBuddy!) {
        
        buddies = sipManager.buddyList()
        refresh()
        tableView.reloadData()
    }
}
