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
-(void)pjsip_onIncomingCall:(int) callId callInfo:(PJSIPCallInfo*) callInfo;
@optional
-(void)pjsip_onCallOnCalling:(int) callId callInfo:(PJSIPCallInfo*) callInfo;
-(void)pjsip_onCallDidConfirm:(int) callId callInfo:(PJSIPCallInfo*) callInfo;
-(void)pjsip_onCallDidHangUp:(int) callId callInfo:(PJSIPCallInfo*) callInfo;
-(void)pjsip_onAccountRegisterStateChanged:(int) accId statusCode:(int)statusCode;
-(void)pjsip_onAccountRegistered:(int) accId;
-(void)pjsip_onAccountUnRegistered:(int) accId;

@end