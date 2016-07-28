//
//  PJSIPDelegate.h
//  TryHard
//
//  Created by Sergei on 7/17/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

#include "PJSIPCallInfo.h"

@protocol PJSIPDelegate;

@protocol PJSIPDelegate <NSObject>

@required
@optional
//calls
-(void)pjsip_onIncomingCall:(int) callId callInfo:(PJSIPCallInfo*) callInfo;
-(void)pjsip_onCallOnCalling:(int) callId callInfo:(PJSIPCallInfo*) callInfo;
-(void)pjsip_onCallDidConfirm:(int) callId callInfo:(PJSIPCallInfo*) callInfo;
-(void)pjsip_onCallDidHangUp:(int) callId callInfo:(PJSIPCallInfo*) callInfo;
//message
-(void)pjsip_onMessageIncome:(int) callId callInfo:(PJSIPCallInfo*) callInfo
                    message:(NSString *)message
                      sender:(NSString*)sender;

@end