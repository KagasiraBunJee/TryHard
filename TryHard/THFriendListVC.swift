//
//  THFriendListVC.swift
//  TryHard
//
//  Created by Sergei on 7/22/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

import UIKit

class THFriendListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchFriend: THTextField!
    
    var sipManager:THPJSipManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sipManager = THPJSipManager.sharedManager()
        
        tableView.tableFooterView = UIView()
        
        searchFriend.onDone = {
            
            let id = self.sipManager.findBuddy(self.searchFriend.text!)
            print("buddy found with id \(id)")
            
        }
    }

    
}
