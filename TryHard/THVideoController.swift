//
//  THVideoController.swift
//  TryHard
//
//  Created by Sergey on 6/17/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

import UIKit
import AVFoundation

class THVideoController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    var videoDataOutput: AVCaptureVideoDataOutput!
    var videoDataOutputQueue : dispatch_queue_t!
    var previewLayer:AVCaptureVideoPreviewLayer!
    var captureDevice : AVCaptureDevice!
    let session = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initCamera()
    }

    func initCamera() {
        
        let inputDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let captureInput:AVCaptureDeviceInput?
        
        do {
            captureInput = try AVCaptureDeviceInput(device: inputDevice)
        } catch let error as NSError {
            print(error)
            return
        }
        
        let captureOut = AVCaptureVideoDataOutput()
        
        captureOut.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        
        session.sessionPreset = AVCaptureSessionPresetMedium
        
        if session.canAddInput(captureInput) {
            session.addInput(captureInput)
        }
        
        if session.canAddOutput(captureOut) {
            session.addOutput(captureOut)
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = self.imageView.frame
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        imageView.layer.addSublayer(previewLayer)
    }
    
    //MARK:- IBActions
    @IBAction func startAction(sender: AnyObject) {
    }
    
    @IBAction func stopAction(sender: AnyObject) {
    }
    
    @IBAction func detectAction(sender: AnyObject) {
    }
}
