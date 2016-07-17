//
//  THCameraManager.h
//  TryHard
//
//  Created by Sergey on 6/21/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <AVFoundation/AVFoundation.h>

@interface THCameraManager : NSObject

-(id) initWithParentView: (UIView*) view;
-(void) setParentView:(UIView*) view;
-(void) startSession;
-(void) stopSession;

@end
