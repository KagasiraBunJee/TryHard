//
//  BTDevice.h
//  TryHard
//
//  Created by Sergey on 6/13/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTDevice : NSObject

@property (strong, nonatomic, readonly) NSString* name;
@property (strong, nonatomic, readonly) NSString* address;
@property (assign, nonatomic, readonly) NSUInteger majorClass;
@property (assign, nonatomic, readonly) NSUInteger minorClass;
@property (assign, nonatomic, readonly) NSInteger type;
@property (assign, nonatomic, readonly) BOOL supportsBatteryLevel;
@property (strong, nonatomic, readonly) NSDate* detectingDate;

- (instancetype)initWithBluetoothDevice:(NSObject*)bluetoothDevice;
- (instancetype)init __unavailable;
- (BOOL)isEqual:(id)object;
- (NSUInteger)hash;

@end
