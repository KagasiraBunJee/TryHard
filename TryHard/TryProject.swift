//
//  TryProject.swift
//  TryHard
//
//  Created by Sergey on 3/18/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

import UIKit

class TryProject {

    var title = ""
    var projectInfo = ""
    var storyBoardID = ""
    var viewController:UIViewController?
    
    convenience init(title:String, projectInfo:String, vc:UIViewController) {
        
        self.init()
        
        self.title = title
        self.projectInfo = projectInfo
        self.viewController = vc
    }
}
