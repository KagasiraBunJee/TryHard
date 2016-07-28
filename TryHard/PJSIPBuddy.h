//
//  PJSIPBuddy.h
//  TryHard
//
//  Created by Sergei on 7/27/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BUDDY_STATUS) {
    BUDDY_STATUS_UNKNOWN,
    BUDDY_STATUS_OFFLINE,
    BUDDY_STATUS_ONLINE
};

@interface PJSIPBuddy : NSObject

@property (nonatomic, assign, readonly) int buddyID;
@property (nonatomic, retain, readonly) NSString *buddyURI;
@property (nonatomic, retain, readonly) NSString *buddyLogin;
@property (nonatomic, readonly) BUDDY_STATUS buddyStatus;
@property (nonatomic, retain, readonly) NSString *buddyStatusStr;

-(id)initWithBuddyId:(int)buddyID;

@end
