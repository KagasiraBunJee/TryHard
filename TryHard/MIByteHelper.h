//
//  MIByteHelper.h
//  TryHard
//
//  Created by Sergei on 6/15/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIByteHelper : NSObject

+ (NSUInteger)CRC8WithBytes:(Byte*)bytes length:(NSUInteger)length;

@end
