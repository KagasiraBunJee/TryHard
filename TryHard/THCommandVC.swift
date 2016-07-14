//
//  THCommandVC.swift
//  TryHard
//
//  Created by Sergey on 7/1/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

import UIKit
import AVFoundation

class THCommandVC: UIViewController, AVAudioRecorderDelegate {

    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    var audioFile:NSString!
    
    let commandManager = THCommandListener.sharedManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        recordingSession = AVAudioSession.sharedInstance()
        audioFile = documentDir().stringByAppendingPathComponent("recording.raw")
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] (allowed: Bool) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    if allowed {
                        
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }
    }

    func documentDir() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    //MARK:- IBActions
    @IBAction func startRecord(sender: AnyObject) {
        
        let audioURL = NSURL(fileURLWithPath: audioFile as String)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 8000.0,
            AVNumberOfChannelsKey: 1 as NSNumber,
            AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue,
            AVLinearPCMBitDepthKey: NSNumber(int: 16)
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(URL: audioURL, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
//            recordButton.setTitle("Tap to Stop", forState: .Normal)
        } catch let error as NSError {
            print(error)
//            finishRecording(success: false)
        }

    }
    
    @IBAction func stopRecord(sender: AnyObject) {
        audioRecorder.stop()
        audioRecorder = nil

        commandManager.parseCommand(String(format: "%@", audioFile))
    }
}
