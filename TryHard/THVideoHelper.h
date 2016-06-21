//
//  THVideoHelper.h
//  TryHard
//
//  Created by Sergey on 6/20/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <AVFoundation/AVFoundation.h>

@interface THVideoHelper : NSObject

+(UIImage *)inspectVideoWithAddress:(void *)address width:(int) width height:(int) height;
+(CGImageRef) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer;
+(NSData *) dataFromSampleBuffer:(CMSampleBufferRef) sampleBuffer;
+(UIImage *) sampleBuffer:(CMSampleBufferRef) sampleBuffer;
+(NSArray *)createIplImageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer;

@end
