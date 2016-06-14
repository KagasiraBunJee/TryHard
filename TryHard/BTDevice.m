//
//  BTDevice.m
//  TryHard
//
//  Created by Sergey on 6/13/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

#import "BTDevice.h"
#import <Foundation/Foundation.h>

@interface BTDevice ()

@property (strong, nonatomic, readwrite) NSString* name;
@property (strong, nonatomic, readwrite) NSString* address;
@property (assign, nonatomic, readwrite) NSUInteger majorClass;
@property (assign, nonatomic, readwrite) NSUInteger minorClass;
@property (assign, nonatomic, readwrite) NSInteger type;
@property (assign, nonatomic, readwrite) BOOL supportsBatteryLebel;
@property (strong, nonatomic, readwrite) NSDate* detectingDate;

@end

@implementation BTDevice


- (instancetype)initWithBluetoothDevice:(NSObject *)bluetoothDevice
{
    self = [super init];
    
//    BluetoothDevice device = (BluetoothDevice)bluetoothDevice;
//    
//    _name = device.name;
//    _address = device.address;
//    _majorClass = device.majorClass;
//    _minorClass = device.minorClass;
//    _type = device.type;
//    _supportsBatteryLevel = device.supportsBatteryLevel;
//    _detectingDate = [[NSDate alloc] init];
    
    return self;
}

- (BOOL)isEqualToBluetoothDevice:(BTDevice*)bluetoothDevice
{
    if (!bluetoothDevice) {
        return NO;
    }
    return [self.address isEqualToString:bluetoothDevice.address];
}

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[BTDevice class]]) {
        return NO;
    }
    return [self isEqualToBluetoothDevice:object];
}

- (NSUInteger)hash
{
    return [self.address hash];
}

@end
