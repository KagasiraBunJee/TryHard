//
//  THPJSipManager.h
//  TryHard
//
//  Created by Sergey on 7/14/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PJSIPDelegate.h"
#import "PJSIPRegisterDelegate.h"
#import "PJSIPBuddyDelegate.h"
#import "PJSIPCredention.h"
#import "PJSIPBuddy.h"

@interface THPJSipManager : NSObject

//delegates
@property (weak) id<PJSIPDelegate> delegate;
@property (weak) id<PJSIPRegisterDelegate> regDelegate;
@property (weak) id<PJSIPBuddyDelegate> buddyDelegate;

//calls
@property (nonatomic, assign, readonly) int calls;
@property (nonatomic, assign, readonly) int incomingCalls;

//settings
@property (nonatomic, retain) NSString *outboundProxy;
@property (nonatomic, retain) NSString *outboundProxyPort;
@property (nonatomic) UIView *videoView;

+(THPJSipManager*) sharedManager;

-(void)start;
-(BOOL)started;

//acc methods
-(void)registerUser:(PJSIPCredention *)cred userInfo:(void* ) userInfo;
-(void)setAccountPresence:(int)acc_id online:(BOOL)presence;

//call methods
-(void)callTo:(NSString *)sipUser withVideo:(BOOL) withVideo;
-(void)answer:(int) call_id withVideo:(BOOL) withVideo;
-(void)hangUp:(int) call_id withMessage:(NSString*)message;
-(void)busy:(int) call_id withMessage:(NSString*)message;
-(void)hangUpAll;
-(void)holdCall:(int) call_id;
-(void)unholdCall:(int) call_id;

//message
-(void)sendMessage:(NSString*)msg destURI:(NSString*)destURI call_id:(int)call_id;
-(void)notifyTyping:(NSString *)destURI isTyping:(BOOL)isTyping;

-(NSData*)getAccInfo:(int)acc_id;

//Friends methods
-(void)addBuddy:(NSString *)buddyURI;
-(NSArray<PJSIPBuddy*> *)buddyList;
-(int)boddiesCount;

@end
