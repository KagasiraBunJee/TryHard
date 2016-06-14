//
//  THSocketVC.swift
//  TryHard
//
//  Created by Sergey on 5/20/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

import UIKit
import DGActivityIndicatorView
import CocoaAsyncSocket

enum THSocketCommand : String {
    case JOIN = "iam"
    case MESSAGE = "msg"
    case ELSE = ""
}

enum THCommandTag : Int {
    case JOINING = 0
    case MESSAGE = 1
    case ELSE = -1
}

enum IndicatorStatus {
    case ERROR
    case WARNING
    case SUCCESS
}

class THMessage {
    var author:String
    var text:String
    var isServer:Bool = false
    
    init (author:String, text:String, isServer:Bool = false) {
        self.text = text
        self.isServer = isServer
        self.author = author
    }
}

class THSocketVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, GCDAsyncSocketDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chatText: UITextField!
    @IBOutlet weak var userName: UITextField!
    
    //MARK:- Status assets
    @IBOutlet weak var statusContainer: UIView!
    @IBOutlet weak var statusMessage: UILabel!
    @IBOutlet weak var statusSpinnerContainer: UIView!
    @IBOutlet weak var statusHeightConstraint: NSLayoutConstraint!
    
    var statusIndicator:DGActivityIndicatorView!
    var statusHeightConstant:CGFloat = 50
    //MARK:- Status assets end
    
    private var activeTF:UITextField!
    
    var messages = NSMutableArray()
    
    var socket:GCDAsyncSocket!
    
    var host = "admin.mapamagic.com"
    var port = 3001
    var errorOccured = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initIndicator()
        hideIndicator()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 158.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(THSocketVC.showKeyboard(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(THSocketVC.hideKeyboard(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        socket = GCDAsyncSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
        
        showIndicator("Connecting to server...")
        startConnection()
    }

    override func willMoveToParentViewController(parent: UIViewController?) {
        if parent == nil {
            socket.disconnect()
        }
    }
    
    //MARK:- Connection
    func startSocket() {
        
        do {
            try self.socket.connectToHost(self.host, onPort: UInt16(self.port))
        } catch let error as NSError {
            print("socket error: ",error)
        }
    }
    
    func endSocket() {
        socket.disconnect()
    }
    
    func startConnection() {
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.startSocket()
        }
        
    }
    
    func stopConnection() {
        hideIndicator()
        endSocket()
    }
    
    //MARK:- Indicator
    func initIndicator() {
        statusIndicator = DGActivityIndicatorView(type: .BallClipRotateMultiple,tintColor: UIColor.whiteColor())
        statusIndicator.frame = CGRectMake(0, 0, statusSpinnerContainer.frame.width, statusSpinnerContainer.frame.height)
        statusSpinnerContainer.addSubview(statusIndicator)
    }
    
    func showIndicator(statusText: String?, status:IndicatorStatus = .WARNING) {
        
        statusIndicator.startAnimating()
        statusMessage.text = statusText
        
        var color = UIColor(red: 1.0, green: 0.0, blue: 0.0094, alpha: 0.5)
        
        switch status {
        case .ERROR:
            color = UIColor(red: 1.0, green: 0.0, blue: 0.0094, alpha: 0.5)
        case .WARNING:
            color = UIColor(red: 0.9859, green: 0.707, blue: 0.0, alpha: 0.5)
        case .SUCCESS:
            color = UIColor(red: 0.0, green: 0.9859, blue: 0.0174, alpha: 0.5)
        }
        
        statusContainer.backgroundColor = color
        
        UIView.animateWithDuration(0.5) { 
            self.statusHeightConstraint.constant = self.statusHeightConstant
        }
    }
    
    func hideIndicator() {
        statusIndicator.stopAnimating()
        statusMessage.text = ""
        
        UIView.animateWithDuration(0.5) {
            self.statusHeightConstraint.constant = 0
        }
    }
    
    //MARK:- Actions
    @IBAction func reconnect(sender: AnyObject) {
        startConnection()
    }
    
    @IBAction func joinChat(sender: AnyObject) {
        
//        if let username = userName.text where !username.isEmpty {
//            sendCommand(username, commandType: .JOIN, tag: THCommandTag.JOINING.rawValue)
//        } else {
//            showAlert(withMessage: "Enter your username")
//        }
        sendCommand("[\"subscribe\",[27043887009,27043887694,27043887876]]", commandType: .ELSE)
    }
    
    @IBAction func sendMessage(sender: AnyObject) {
        
        if !chatText.text!.isEmpty {
            sendText(chatText.text!)
        }
    }
    
    //MARK:- Custom
    func sendCommand(value: NSString, commandType type:THSocketCommand, tag:Int = 0) {
        
        var commandValue:NSString!
        
        switch type {
        case .JOIN:
            commandValue = "\(type.rawValue):\(value)"
        case .MESSAGE:
            commandValue = "\(type.rawValue):\(value)"
        default:
            commandValue = value
        }
        
        socket.writeData(commandValue.dataUsingEncoding(NSUTF8StringEncoding)!, withTimeout: 0, tag: tag)
    }
    
    func dataReceived(data:NSData) {
        
        let message = NSString(data: data, encoding: NSUTF8StringEncoding)!
        
        let args = message.componentsSeparatedByString(":")
        var isServer = false
        
        if args[0] == "server" {
            isServer = true
        }

        addMessage(args[1], isServerMessage: isServer, author: args[0])
    }
    
    func addMessage(message:NSString, isServerMessage isServer:Bool, author:NSString) {
        
        messages.addObject(
            THMessage(author: author as String, text: message as String, isServer: isServer)
        )
        
        tableView.reloadData()
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: messages.count-1, inSection: 0), atScrollPosition: .Bottom, animated: true)
    }
    
    func sendText(text:NSString) {
        
        sendCommand(text, commandType: .MESSAGE, tag: THCommandTag.MESSAGE.rawValue)
    }
    
    //MARK:- UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let message = messages.objectAtIndex(indexPath.row) as! THMessage
        
        if message.isServer {
            let cell = tableView.dequeueReusableCellWithIdentifier("messageCell") as! THChatCell
            
            cell.setMessage(message.author, text: message.text, isServer: message.isServer)
            
            return cell
        } else {
            
            if message.author == userName.text! {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("authorCell") as! THNewChatCell
                cell.authorName.text = message.author
                cell.message.text = message.text
                cell.message.sizeToFit()
                cell.layoutIfNeeded()
                
                return cell
            } else {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("userCell") as! THNewChatCell
                cell.authorName.text = message.author
                cell.message.text = message.text
                cell.message.sizeToFit()
                cell.layoutIfNeeded()
                
                return cell
            }
        }
        
    }
    
    //MARK:- UITableViewDelegate
    
    //MARK:- UITextViewDelegate
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        activeTF = textField
        return true
    }
    
    //MARK:- Keyboard show/hide
    func showKeyboard(aNotification:NSNotification){
        let info:NSDictionary = aNotification.userInfo!
        let size:CGSize = info.objectForKey(UIKeyboardFrameBeginUserInfoKey)!.CGRectValue.size
        
        if (activeTF != nil) {
            let height = self.view.frame.height - activeTF.frame.origin.y - activeTF.frame.height
            
            if height < size.height {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.view.frame.origin.y -= fabs(size.height-height)
                })
            }
        }
        
    }
    
    func hideKeyboard(sender:AnyObject){
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.view.frame.origin.y = 0
        })
    }
    
    //MARK:- GCDAsyncSocketDelegate
    func socket(sock: GCDAsyncSocket!, didConnectToHost host: String!, port: UInt16) {
        NSLog("didConnectToHost %@:%i", host, port)
        
        sock.readDataWithTimeout(-1, tag: 5)
        addMessage("Connected to server.", isServerMessage: true, author: "server")
        errorOccured = false
        hideIndicator()
    }
    
    func socketDidDisconnect(sock: GCDAsyncSocket!, withError err: NSError!) {
        print("socketDidDisconnect: ", err)
        
        if !errorOccured {
            
            showIndicator("Connecting to server...")
            
            switch err.code {
            case 7:
                addMessage("Server has closed connection.", isServerMessage: true, author: "server")
            default:
                addMessage("Can't connect to server.", isServerMessage: true, author: "server")
            }
            
            endSocket()
            errorOccured = true
        }
        
        startConnection()
    }
    
    func socketDidCloseReadStream(sock: GCDAsyncSocket!) {
        print("socketDidCloseReadStream")
    }
    
    func socket(sock: GCDAsyncSocket!, didReadData data: NSData!, withTag tag: Int) {
        
        dataReceived(data)
    }
    
    func socket(sock: GCDAsyncSocket!, didWriteDataWithTag tag: Int) {
        sock.readDataWithTimeout(-1, tag: tag)
    }
    
}
