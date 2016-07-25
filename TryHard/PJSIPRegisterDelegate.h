//
//  PJSIPRegisterDelegate.h
//  TryHard
//
//  Created by Sergey on 7/25/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

@protocol PJSIPRegisterDelegate;

@protocol PJSIPRegisterDelegate <NSObject>

@required
@optional
-(void)pjsip_onAccountRegisterStateChanged:(int) accId statusCode:(int)statusCode;
-(void)pjsip_onAccountRegistered:(int) accId;
-(void)pjsip_onAccountUnRegistered:(int) accId;

@end
