//
//  MIByteHelper.m
//  TryHard
//
//  Created by Sergei on 6/15/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

#import "MIByteHelper.h"

@implementation MIByteHelper

+ (NSUInteger)CRC8WithBytes:(Byte*)bytes length:(NSUInteger)length {
    NSUInteger checksum = 0;
    for (NSUInteger i = 0; i < length; i++) {
        checksum ^= bytes[i];
        for (NSUInteger j = 0; j < 8; j++) {
            if (checksum & 0x1) {
                checksum = (0x8c ^ (0xff & checksum >> 1));
            } else {
                checksum = (0xff & checksum >> 1);
            }
        }
    }
    return checksum;
}

@end
