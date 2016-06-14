//
//  QExpandVC.swift
//  TryHard
//
//  Created by Sergey on 5/13/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

import UIKit

class QExpandVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let tableViewContent:[Array<String>] = [
        [
            "Value 1",
            "Value 2",
            "Value 3"
        ],
        [
            "Value 4",
            "Value 5",
            "Value 6"
        ]
    ]
    
    var hiddenSections = NSMutableDictionary()
    
    var hiddenSection = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK:- UITapGestureRecognizer
    func sectionTapped(gesture:UIGestureRecognizer) {
        
        if let view = gesture.view {
            
            let section = view.tag
            
            if hiddenSections.objectForKey(section) != nil {
                hiddenSections.removeObjectForKey(section)
            } else {
                hiddenSections.setObject(section, forKey: section)
            }
            
            let set = NSMutableIndexSet()
            set.addIndex(section)
            
            tableView.reloadSections(set, withRowAnimation: UITableViewRowAnimation.None)
        }
    }
    
    //MARK:- UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if hiddenSections.objectForKey(section) != nil {
            return 0
        }
        
        return tableViewContent[section].count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableViewContent.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("expandCell")!
        
        cell.textLabel!.text = tableViewContent[indexPath.section][indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRectMake(0, 0, self.tableView.frame.width, 50))
        view.backgroundColor = UIColor.whiteColor()
        view.tag = section
        let label = UILabel(frame: view.frame)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.sectionTapped(_:)))
        view.addGestureRecognizer(gesture)
        
        var isHidden = ""
        
        if hiddenSections.objectForKey(section) != nil {
            isHidden = " hidden"
        }
        
        let title = "Section \(section+1)"+isHidden
        
        label.text = title
        
        view.addSubview(label)
        return view
    }
}
