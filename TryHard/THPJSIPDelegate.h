//
//  THPJSIPDelegate.h
//  TryHard
//
//  Created by Sergei on 7/17/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

#include "PJSIPCallInfo.h"

@protocol THPJSipManagerDelegate;

@protocol THPJSipManagerDelegate <NSObject>

@required
@optional
//calls
-(void)pjsip_onIncomingCall:(int) callId callInfo:(PJSIPCallInfo*) callInfo;
-(void)pjsip_onCallOnCalling:(int) callId callInfo:(PJSIPCallInfo*) callInfo;
-(void)pjsip_onCallDidConfirm:(int) callId callInfo:(PJSIPCallInfo*) callInfo;
-(void)pjsip_onCallDidHangUp:(int) callId callInfo:(PJSIPCallInfo*) callInfo;
//accounts
-(void)pjsip_onAccountRegisterStateChanged:(int) accId statusCode:(int)statusCode;
-(void)pjsip_onAccountRegistered:(int) accId;
-(void)pjsip_onAccountUnRegistered:(int) accId;
//buddies
-(void)pjsip_onFriendRequestReceived:(int) buddyId buddyURI:(NSString*)buddyURI reason:(NSString*)reason msg:(NSString*)msg;

@end