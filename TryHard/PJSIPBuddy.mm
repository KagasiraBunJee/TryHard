//
//  PJSIPBuddy.m
//  TryHard
//
//  Created by Sergei on 7/27/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

#import "PJSIPBuddy.h"
#include "pjsua.h"

@implementation PJSIPBuddy

-(id)initWithBuddyId:(int)buddyID
{
    self = [super init];
    if(self) {
        
        pjsua_buddy_info b_info;
        pjsua_buddy_get_info(buddyID, &b_info);
        
        _buddyID = buddyID;
        _buddyURI = [NSString stringWithCString:b_info.uri.ptr encoding:NSUTF8StringEncoding];
        _buddyLogin = [[_buddyURI componentsSeparatedByString:@"@"][0] substringWithRange:NSMakeRange(4, [_buddyURI componentsSeparatedByString:@"@"][0].length-4)];
        _buddyStatusStr = [NSString stringWithCString:b_info.status_text.ptr encoding:NSUTF8StringEncoding];
        
        switch (b_info.status) {
            case PJSUA_BUDDY_STATUS_UNKNOWN:
                _buddyStatus = BUDDY_STATUS_UNKNOWN;
                break;
            case PJSUA_BUDDY_STATUS_OFFLINE:
                _buddyStatus = BUDDY_STATUS_OFFLINE;
                break;
            case PJSUA_BUDDY_STATUS_ONLINE:
                _buddyStatus = BUDDY_STATUS_ONLINE;
                break;
        }
    }
    return self;
}

@end
