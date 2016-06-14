//
//  THBluetoothManager.swift
//  TryHard
//
//  Created by Sergey on 6/13/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

import Foundation

//@objc protocol BluetoothManager {
//    
//    var lastInitError:UInt32 { get }
//    func setSharedInstanceQueue(arg1: AnyObject?)
//    static func sharedInstance() -> BluetoothManager
//    func _advertisingChanged()
//    func setConnectable(arg1:Bool)
//    func setDevicePairingEnabled(arg1:Bool)
//    func setDeviceScanningEnabled(arg1:Bool)
//    func setDiscoverable(arg1:Bool)
//    func setEnabled(arg1:Bool)
//    func setPowered(arg1:Bool)
//    func connectDevice(arg1:AnyObject)
//    func scanForServices(arg1: UInt32)
//    + (int)lastInitError;
//    + (void)setSharedInstanceQueue:(id)arg1;
//    + (id)sharedInstance;
//    
//    //- (struct BTAccessoryManagerImpl { }*)_accessoryManager;
//    - (void)_advertisingChanged;
//    - (BOOL)_attach:(id)arg1;
//    - (void)_cleanup:(BOOL)arg1;
//    - (void)_connectabilityChanged;
//    - (void)_connectedStatusChanged;
//    - (void)_discoveryStateChanged;
//    - (BOOL)_onlySensorsConnected;
//    - (void)_postNotification:(id)arg1;
//    - (void)_postNotificationWithArray:(id)arg1;
//    - (void)_powerChanged;
//    - (void)_removeDevice:(id)arg1;
//    - (void)_restartScan;
//    - (void)_scanForServices:(unsigned int)arg1 withMode:(int)arg2;
//    - (void)_setScanState:(int)arg1;
//    - (BOOL)_setup:(struct BTSessionImpl { }*)arg1;
//    - (void)acceptSSP:(int)arg1 forDevice:(id)arg2;
//    - (id)addDeviceIfNeeded:(struct BTDeviceImpl { }*)arg1;
//    - (BOOL)audioConnected;
//    - (BOOL)available;
//    - (void)cancelPairing;
//    - (void)connectDevice:(id)arg1;
//    - (void)connectDevice:(id)arg1 withServices:(unsigned int)arg2;
//    - (BOOL)connectable;
//    - (BOOL)connected;
//    - (id)connectedDevices;
//    - (id)connectingDevices;
//    - (void)dealloc;
//    - (BOOL)devicePairingEnabled;
//    - (BOOL)deviceScanningEnabled;
//    - (BOOL)deviceScanningInProgress;
//    - (void)disconnectDevice:(id)arg1;
//    - (void)enableTestMode;
//    - (BOOL)enabled;
//    - (void)endVoiceCommand:(id)arg1;
//    - (id)init;
//    - (BOOL)isAnyoneAdvertising;
//    - (BOOL)isAnyoneScanning;
//    - (BOOL)isDiscoverable;
//    - (BOOL)isServiceSupported:(unsigned int)arg1;
//    - (id)localAddress;
//    - (id)pairedDevices;
//    - (void)postNotification:(id)arg1;
//    - (void)postNotificationName:(id)arg1 object:(id)arg2;
//    - (void)postNotificationName:(id)arg1 object:(id)arg2 error:(id)arg3;
//    - (int)powerState;
//    - (BOOL)powered;
//    - (void)resetDeviceScanning;
//    - (void)scanForConnectableDevices:(unsigned int)arg1;
//    - (void)scanForServices:(unsigned int)arg1;
//    - (void)setAudioConnected:(BOOL)arg1;

//    - (void)setPincode:(id)arg1 forDevice:(id)arg2;
//    - (void)showPowerPrompt;
//    - (void)startVoiceCommand:(id)arg1;
//    - (void)unpairDevice:(id)arg1;
//    - (BOOL)wasDeviceDiscovered:(id)arg1;
//    
//    // Image: /System/Library/PrivateFrameworks/GameKitServices.framework/GameKitServices
//    
//    - (int)localDeviceSupportsService:(unsigned int)arg1;
    
//}