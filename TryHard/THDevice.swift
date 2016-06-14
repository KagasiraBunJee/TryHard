//
//  THDevice.swift
//  TryHard
//
//  Created by Sergey on 6/13/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

import Foundation

@objc protocol BluetoothDevice {
    
    func clearName()
    var isNameCached:Bool { get }
    func acceptSSP(arg1:Int32)
    var address:AnyObject? { get }
    var batteryLevel:Int32 { get }
    var cloudPaired:Bool { get }
    func compare(arg1:AnyObject?) -> Int32
    func connect()
    func connectWithServices(arg1:UInt32)
    var connected:Bool { get }
    var connectedServices:UInt32 { get }
    var connectedServicesCount:UInt32 { get }
//    - (id)copyWithZone:(struct _NSZone { }*)arg1;
//    - (void)dealloc;
//    - (id)description;
//    //- (struct BTDeviceImpl { }*)device;
    func disconnect()
    func endVoiceCommand()
    func getServiceSetting(arg1:UInt32, arg2:AnyObject?) -> AnyObject?
    var isAccessory:Bool { get }
    func isServiceSupported(arg1:UInt32) -> Bool
    var majorClass:UInt32 { get }
    var minorClass:UInt32 { get }
    var name:NSString? { get }
    var paired:Bool { get }
    var productId:UInt32 { get }
    var scoUID: AnyObject? { get }
    func setPIN(arg1:UInt32)
    func setServiceSetting(arg1:UInt32, arg2:AnyObject?, arg3:AnyObject?)
    func setSyncGroup(arg1:AnyObject?, arg2:Bool)
    func startVoiceCommand()
    var supportsBatteryLevel:Bool { get }
    func syncGroups() -> AnyObject?
    var type:AnyObject? { get }
    func unpair()
    var vendorId:UInt32 { get }
    
//    init(device arg1:AnyObject, arg2:AnyObject)
//    struct {} syncSettings
//    - (id)initWithDevice:(struct BTDeviceImpl { }*)arg1 address:(id)arg2;
    
//    - (void)setDevice:(struct BTDeviceImpl { }*)arg1;
    
//    - (void)setServiceSetting:(unsigned int)arg1 key:(id)arg2 value:(id)arg3;
    
//    - (void)setSyncSettings:(struct { BOOL x1; BOOL x2; BOOL x3; BOOL x4; })arg1;

//    - (struct { BOOL x1; BOOL x2; BOOL x3; BOOL x4; })syncSettings;
    
}

struct BTSyncSettings {
    var x1:Bool
    var x2:Bool
    var x3:Bool
    var x4:Bool
}