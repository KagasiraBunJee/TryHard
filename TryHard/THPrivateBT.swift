//
//  THPrivateBT.swift
//  TryHard
//
//  Created by Sergey on 6/10/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

import UIKit
import Foundation

class THPrivateBT: UIViewController {

//    var bt:BluetoothManager!
    
    let observers = [
        "BluetoothPowerChangedNotification",
        "BluetoothAvailabilityChangedNotification",
        "BluetoothDeviceDiscoveredNotification",
        "BluetoothDeviceRemovedNotification"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(powerChanged(_:)), name: "BluetoothPowerChangedNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(availability(_:)), name: "BluetoothAvailabilityChangedNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(deviceDiscovered(_:)), name: "BluetoothDeviceDiscoveredNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(deviceRemoved(_:)), name: "BluetoothDeviceRemovedNotification", object: nil)
        
        dlopen("/System/Library/PrivateFrameworks/BluetoothManager.framework/BluetoothManager",RTLD_LOCAL)
//        let eventsclass = unsafeBitCast(NSClassFromString("BluetoothManager"), BluetoothManager.Type.self)
//        bt = eventsclass.sharedInstance()
        
//        bt.setPowered(true)
//        bt.setEnabled(true)
        
    }
    
    //MARK:- Bluetooth notifications
    func powerChanged(notification:NSNotification) {
        print("powerChanged: \(notification.object)")
    }
    
    func availability(notification:NSNotification) {
        print("availability: \(notification.description)")
        
//        if let value = notification.object as? NSNumber {
//            if value.boolValue {
//                bt.setDeviceScanningEnabled(true)
//                bt.setConnectable(true)
//                bt.setDiscoverable(true)
//                bt.setDevicePairingEnabled(true)
//            }
//        }
    }
    
    func deviceDiscovered(notification:NSNotification) {
        
        if let device = getDevice(notification.object) {
            if device.name == "MI" {
                print("what we do need: \(device.name)")
//                bt.connectDevice(device)
            } else {
                print("wrong device: \(device.name)")
            }
        }
    }
    
    func deviceRemoved(notification:NSNotification) {
//        print("deviceRemoved: \(notification.object)")
    }
    
    //MARK:- Device initiation
    func getDevice(object:AnyObject?) -> BluetoothDevice? {
        
        dlopen("/System/Library/PrivateFrameworks/BluetoothManager.framework/BluetoothDevice",RTLD_LOCAL)
        if let device = unsafeBitCast(object, BluetoothDevice.Type.self) as? BluetoothDevice {
            return device
        }
        
        return nil
    }
}

@objc protocol UIASyntheticEvents {
    static func sharedEventGenerator() -> UIASyntheticEvents
    //@property(readonly) struct __IOHIDEventSystemClient *ioSystemClient; 
    // @synthesize ioSystemClient=_ioSystemClient;     
    var voiceOverStyleTouchEventsEnabled: Bool { get set }
    var activePointCount: UInt64 { get set }
    //@property(nonatomic) CDStruct_3eca2549 *activePoints; 
    // @synthesize activePoints=_activePoints;     
    var gsScreenScale: Double { get set }
    var gsScreenSize: CGSize { get set }
    var screenSize: CGSize { get set }
    var screen: UIScreen { get set }
    var onScreenRect: CGRect { get set }
    func sendPinchCloseWithStartPoint(_: CGPoint, endPoint: CGPoint, duration: Double, inRect: CGRect)
    func sendPinchOpenWithStartPoint(_: CGPoint, endPoint: CGPoint, duration: Double, inRect: CGRect)
    func sendDragWithStartPoint(_: CGPoint, endPoint: CGPoint, duration: Double, withFlick: Bool, inRect: CGRect)
    func sendRotate(_: CGPoint, withRadius: Double, rotation: Double, duration: Double, touchCount: UInt64)
    func sendMultifingerDragWithPointArray(_: UnsafePointer<CGPoint>, numPoints: Int32, duration: Double, numFingers: Int32)
    func sendPinchCloseWithStartPoint(_: CGPoint, endPoint: CGPoint, duration: Double)
    func sendPinchOpenWithStartPoint(_: CGPoint, endPoint: CGPoint, duration: Double)
    func sendFlickWithStartPoint(_: CGPoint, endPoint: CGPoint, duration: Double)
    func sendDragWithStartPoint(_: CGPoint, endPoint: CGPoint, duration: Double)
    func sendTaps(_: Int, location: CGPoint, withNumberOfTouches: Int, inRect: CGRect)
    func sendDoubleFingerTap(_: CGPoint)
    func sendDoubleTap(_: CGPoint)
    func _sendTap(_: CGPoint, withPressure: Double)
    func sendTap(_: CGPoint)
    func _setMajorRadiusForAllPoints(_: Double)
    func _setPressureForAllPoints(_: Double)
    func moveToPoints(_: UnsafePointer<CGPoint>, touchCount: UInt64, duration: Double)
    func _moveLastTouchPoint(_: CGPoint)
    func liftUp(_: CGPoint)
    func liftUp(_: CGPoint, touchCount: UInt64)
    func liftUpAtPoints(_: UnsafePointer<CGPoint>, touchCount: UInt64)
    func touchDown(_: CGPoint)
    func touchDown(_: CGPoint, touchCount: UInt64)
    func touchDownAtPoints(_: UnsafePointer<CGPoint>, touchCount: UInt64)
    func shake()
    func setRinger(_: Bool)
    func holdVolumeDown(_: Double)
    func clickVolumeDown()
    func holdVolumeUp(_: Double)
    func clickVolumeUp()
    func holdLock(_: Double)
    func clickLock()
    func lockDevice()
    func holdMenu(_: Double)
    func clickMenu()
    func _sendSimpleEvent(_: Int)
    func setOrientation(_: Int32)
    func sendAccelerometerX(_: Double, Y: Double, Z: Double, duration: Double)
    func sendAccelerometerX(_: Double, Y: Double, Z: Double)
    func _updateTouchPoints(_: UnsafePointer<CGPoint>, count: UInt64)
    func _sendHIDVendorDefinedEvent(_: UInt32, usage: UInt32, data: UnsafePointer<UInt8>, dataLength: UInt32) -> Bool
    func _sendHIDScrollEventX(_: Double, Y: Double, Z: Double) -> Bool
    func _sendHIDKeyboardEventPage(_: UInt32, usage: UInt32, duration: Double) -> Bool
    //- (_Bool)_sendHIDEvent:(struct __IOHIDEvent *)arg1;     
    //- (struct __IOHIDEvent *)_UIACreateIOHIDEventType:(unsigned int)arg1;    
    func _isEdgePoint(_: CGPoint) -> Bool
    func _normalizePoint(_: CGPoint) -> CGPoint
    //- (void)dealloc;     
    func _initScreenProperties()
    //- (id)init;
}
