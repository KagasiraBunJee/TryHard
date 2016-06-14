/* Generated by RuntimeBrowser
   Image: /System/Library/PrivateFrameworks/BluetoothManager.framework/BluetoothManager
 */

//#import <objc/runtime.h>

@interface BluetoothDevice : NSObject {
    NSString *_address;
    struct BTDeviceImpl { } *_device;
    NSString *_name;
}

- (void)_clearName;
- (BOOL)_isNameCached;
- (void)acceptSSP:(int)arg1;
- (id)address;
- (int)batteryLevel;
- (BOOL)cloudPaired;
- (int)compare:(id)arg1;
- (void)connect;
- (void)connectWithServices:(unsigned int)arg1;
- (BOOL)connected;
- (unsigned int)connectedServices;
- (unsigned int)connectedServicesCount;
- (id)copyWithZone:(struct _NSZone { }*)arg1;
- (void)dealloc;
- (id)description;
//- (struct BTDeviceImpl { }*)device;
- (void)disconnect;
- (void)endVoiceCommand;
- (id)getServiceSetting:(unsigned int)arg1 key:(id)arg2;
- (id)initWithDevice:(struct BTDeviceImpl { }*)arg1 address:(id)arg2;
- (BOOL)isAccessory;
- (BOOL)isServiceSupported:(unsigned int)arg1;
- (unsigned int)majorClass;
- (unsigned int)minorClass;
- (id)name;
- (BOOL)paired;
- (unsigned int)productId;
- (id)scoUID;
- (void)setDevice:(struct BTDeviceImpl { }*)arg1;
- (void)setPIN:(id)arg1;
- (void)setServiceSetting:(unsigned int)arg1 key:(id)arg2 value:(id)arg3;
- (void)setSyncGroup:(int)arg1 enabled:(BOOL)arg2;
- (void)setSyncSettings:(struct { BOOL x1; BOOL x2; BOOL x3; BOOL x4; })arg1;
- (void)startVoiceCommand;
- (BOOL)supportsBatteryLevel;
- (id)syncGroups;
- (struct { BOOL x1; BOOL x2; BOOL x3; BOOL x4; })syncSettings;
- (int)type;
- (void)unpair;
- (unsigned int)vendorId;

@end
