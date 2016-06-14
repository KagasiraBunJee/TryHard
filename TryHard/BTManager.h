//
//  BTManager.h
//  TryHard
//
//  Created by Sergey on 6/10/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "BluetoothManager.h"

typedef enum MDBluetoothNotification : NSUInteger {
    MDBluetoothPowerChangedNotification,
    MDBluetoothAvailabilityChangedNotification,
    MDBluetoothDeviceDiscoveredNotification,
    MDBluetoothDeviceRemovedNotification,
    MDBluetoothConnectabilityChangedNotification,
    MDBluetoothDeviceUpdatedNotification,
    MDBluetoothDiscoveryStateChangedNotification,
    MDBluetoothDeviceConnectSuccessNotification,
    MDBluetoothConnectionStatusChangedNotification,
    MDBluetoothDeviceDisconnectSuccessNotification
} MDBluetoothNotification;

@protocol MDBluetoothObserverProtocol <NSObject>

@required
- (void)receivedBluetoothNotification:
(MDBluetoothNotification)bluetoothNotification;

@end

@interface BTManager : NSObject

//+ (BluetoothManager*) bluetoothManagerSharedInstance;
+ (BTManager*)sharedInstance;

- (BOOL)bluetoothIsAvailable;

- (void)turnBluetoothOn;
- (BOOL)bluetoothIsPowered;
- (void)turnBluetoothOff;

- (void)startScan;
- (BOOL)isScanning;
- (void)endScan;
- (NSArray*)discoveredBluetoothDevices;

- (void)registerObserver:(id<MDBluetoothObserverProtocol>)observer;
- (void)unregisterObserver:(id<MDBluetoothObserverProtocol>)observer;

@end