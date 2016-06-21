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
    @IBOutlet weak var viewOverlay: UIView!
    
    var videoDataOutput: AVCaptureVideoDataOutput!
    var videoDataOutputQueue : dispatch_queue_t = dispatch_get_main_queue()
    var previewLayer:AVCaptureVideoPreviewLayer!
    var captureDevice : AVCaptureDevice!
    let session = AVCaptureSession()
    
    var currentBuffer:CVImageBuffer!
    var currentImage = UIImage()
    
    var layers:[CALayer] = [CALayer]()
    
    var camera:THCameraManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        initCamera()
    
        camera = THCameraManager(parentView: imageView)
    }

    func initOpenCVCam() {
        
        camera.setParentView(imageView)
        
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
            
            let connection = captureOut.connectionWithMediaType(AVFoundation.AVMediaTypeVideo)
            connection.videoOrientation = .Portrait
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = CGRectMake(0, 0, self.imageView.frame.width, self.imageView.frame.height)
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        imageView.layer.insertSublayer(previewLayer, atIndex: 0)
        
        while layers.count < 100 {
            
            let layer = CALayer()
            layer.borderColor = UIColor.redColor().CGColor
            layer.borderWidth = 3.0
            layer.frame = CGRectZero
            layers.append(layer)
            
            viewOverlay.layer.insertSublayer(layer, atIndex: 0)
        }
        
//        let layer = CALayer()
//        layer.borderColor = UIColor.redColor().CGColor
//        layer.borderWidth = 5.0
//        layer.frame = CGRectMake(50, 50, 100, 100)
//        viewOverlay.layer.insertSublayer(layer, atIndex: 0)

        
        imageView.clipsToBounds = true
    }
    
    func convertSampleBufferToImage(buffer:CVImageBuffer) -> UIImage {
        
        
//        let ciImage = CIImage(CVImageBuffer: buffer)
//        let ctx = CIContext(options: nil)
//        let imageRef = ctx.createCGImage(ciImage, fromRect: CGRectMake(0, 0, CGFloat(CVPixelBufferGetWidth(buffer)), CGFloat(CVPixelBufferGetHeight(buffer))))
//        return UIImage(CIImage: ciImage)
        
//        let srcPtr = Unmanaged.passUnretained(currentBuffer).toOpaque()
//        let pixelBuffer:Unmanaged<CVImageBuffer>? = Unmanaged<CVImageBuffer>.fromOpaque(srcPtr)
//        
//        let cc = unsafeBitCast(pixelBuffer, UnsafeMutablePointer<Unmanaged<CVImageBuffer>?>.self)
        
        CVPixelBufferLockBaseAddress(currentBuffer, UInt64(0))
        
        let addr = CVPixelBufferGetBaseAddressOfPlane(currentBuffer, 0)
        let width = CVPixelBufferGetWidth(currentBuffer)
        let height = CVPixelBufferGetHeight(currentBuffer)
        
        let image = THVideoHelper.inspectVideoWithAddress(addr, width: Int32(width), height: Int32(height))
        
        CVPixelBufferUnlockBaseAddress(currentBuffer, UInt64(0))
        
        return image
    }
    
    //MARK:- IBActions
    @IBAction func startAction(sender: AnyObject) {
        
//        previewLayer.frame = CGRectMake(0, 0, self.imageView.frame.width, self.imageView.frame.height)
//        previewLayer.masksToBounds = true
//        
//        session.startRunning()
        
        camera.startSession()
    }
    
    @IBAction func stopAction(sender: AnyObject) {
//        session.stopRunning()
        camera.stopSession()
    }
    
    @IBAction func detectAction(sender: AnyObject) {
        
        session.stopRunning()
        
        let vc = VCLoader<THHelpVC>.load(storyboardId: .VideoProcessing, inStoryboardID: "THHelpVC")
        vc.image = currentImage
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- AVCaptureVideoDataOutputSampleBufferDelegate
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),{
            
            let bounds = (THVideoHelper.createIplImageFromSampleBuffer(sampleBuffer) as! [NSValue]).map { (value) -> CGRect in
                return value.CGRectValue()
            }
            
            dispatch_async(dispatch_get_main_queue(),{
                for (index,frame) in bounds.enumerate() {
                    self.layers[index].frame = frame
                }
            })
        })
        
        
//        print(bounds)
//        

        
//        let uiimage = UIImage(CGImage: cgimage)
//        let rects = uiimage.textBoundsV2()
//        if rects.count > 0 {
//            print("text found")
//        }

//        let ciImage = CIImage(CVImageBuffer: currentBuffer)
//        let image1 = UIImage(CIImage: ciImage)
//        
//        let image = image1.copy() as! UIImage
//        
//        currentImage = image
//        
//        let rects = image.textBoundsV2()
//        if rects.count > 0 {
//            print("text found")
//        }
    }
}
