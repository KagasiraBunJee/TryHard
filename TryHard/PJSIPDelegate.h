//
//  PJSIPDelegate.h
//  TryHard
//
//  Created by Sergei on 7/17/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

#include "PJSIPCallInfo.h"
#include "PJSIPMessage.h"

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
                     message:(PJSIPMessage *)message
                      sender:(NSString*)sender;
-(void)pjsip_onTyping:(int) callId callInfo:(PJSIPCallInfo*) callInfo
             isTyping:(BOOL) isTyping;

@end