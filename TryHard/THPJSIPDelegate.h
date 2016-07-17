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
-(void)sipOnIncomingCall:(int) callId callInfo:(PJSIPCallInfo*) callInfo;
@optional
-(void)sipOnCallDidConfirm:(int) callId callInfo:(PJSIPCallInfo*) callInfo;
-(void)sipOnCallDidHangUp:(int) callId callInfo:(PJSIPCallInfo*) callInfo;

@end