//
//  THPJSipManager.h
//  TryHard
//
//  Created by Sergey on 7/14/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "THPJSIPDelegate.h"
#import "PJSIPCredention.h"

@interface THPJSipManager : NSObject

@property (nonatomic, weak) id<THPJSipManagerDelegate> delegate;

@property (nonatomic, assign, readonly) int calls;
@property (nonatomic, assign, readonly) int incomingCalls;
@property (nonatomic, retain) NSString *outboundProxy;
@property (nonatomic) UIView *videoView;

+(THPJSipManager*) sharedManager;

- (id)initWithOutboundProxy:(NSString*)outboundProxy port:(NSString*)port;
-(void)registerUser:(PJSIPCredention *)cred userInfo:(void* ) userInfo;

-(void)callTo:(NSString *)sipUser withVideo:(BOOL) withVideo;
-(void)answer:(int) call_id withVideo:(BOOL) withVideo;
-(void)hangUp:(int) call_id;
-(void)holdCall:(int) call_id;
-(void)unholdCall:(int) call_id;

-(NSData*)getAccInfo:(int)acc_id;

//Friends methods

@end
