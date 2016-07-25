//
//  PJSIPBuddyDelegate.h
//  TryHard
//
//  Created by Sergey on 7/25/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

@protocol PJSIPBuddyDelegate;

@protocol PJSIPBuddyDelegate <NSObject>

@required
@optional
-(void)pjsip_onFriendRequestReceived:(int) buddyId buddyURI:(NSString*)buddyURI reason:(NSString*)reason msg:(NSString*)msg;

@end

