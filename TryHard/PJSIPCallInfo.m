//
//  PJSIPCallInfo.m
//  TryHard
//
//  Created by Sergei on 7/17/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

#import "PJSIPCallInfo.h"

@implementation PJSIPCallInfo

-(id)initWithCallID:(int)callID
{
    self = [super init];
    if(self) {
        
        pjsua_call_info ci;
        pjsua_call_get_info(callID, &ci);
        
        _callID = ci.id;
        _accID = ci.acc_id;
        _localInfo = [NSString stringWithFormat:@"%s", ci.local_info.ptr];
        _localContact = [NSString stringWithFormat:@"%s", ci.local_contact.ptr];
        _remoteInfo = [NSString stringWithFormat:@"%s", ci.remote_info.ptr];
        _remoteContact = [NSString stringWithFormat:@"%s", ci.remote_contact.ptr];
        _stateText = [NSString stringWithFormat:@"%s", ci.state_text.ptr];
        _lastStatus = ci.last_status;
        _lastStatusText = [NSString stringWithFormat:@"%s", ci.last_status_text.ptr];
        _mediaStatus = ci.media_status;
        
    }
    return self;
}

@end
