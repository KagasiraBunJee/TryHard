//
//  THFriendListVC.swift
//  TryHard
//
//  Created by Sergei on 7/22/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

import UIKit

class THFriendListVC: UIViewController, UITableViewDataSource, UITableViewDelegate, PJSIPBuddyDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchFriend: THTextField!
    
    var sipManager:THPJSipManager!
    var buddies:[PJSIPBuddy]!
    
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
    
    //MARK:- PJSIPBuddyDelegate
    func pjsip_onBuddyStateChanged(buddyId: Int32, buddy: PJSIPBuddy!) {
        
        buddies = sipManager.buddyList()
        tableView.reloadData()
    }
}
