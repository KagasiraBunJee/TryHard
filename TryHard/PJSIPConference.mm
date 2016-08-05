//
//  PJSIPConference.m
//  TryHard
//
//  Created by Sergey on 8/5/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

#import "PJSIPConference.h"
#include <pjsua-lib/pjsua.h>
#define THIS_FILE "PJSIPConference.m"
#import "THPJSipManager.h"

@implementation PJSIPConference

-(id)initWithCallInfo:(PJSIPCallInfo*)callInfo
{
    self = [super init];
    if(self) {
        
        THPJSipManager *manager = [THPJSipManager sharedManager];
        _id = (int)manager.conferences.count;
        _callInfo = callInfo;
    }
    
    return self;
}

-(void)addParticipant:(PJSIPCallInfo*)callInfo
{
    for (int i = 0; i < self.participants.count; i++)
    {
        PJSIPCallInfo *part = self.participants[i];
        pjsua_conf_connect(callInfo.conf_port, part.conf_port);
        pjsua_conf_connect(part.conf_port, callInfo.conf_port);
    }
    
    NSMutableArray<PJSIPCallInfo*> *participants = [NSMutableArray arrayWithArray:self.participants];
    [participants addObject:callInfo];
    _participants = participants;
}

-(void)removeParticipant:(PJSIPCallInfo*)callInfo
{
    NSMutableArray<PJSIPCallInfo*> *participants = [NSMutableArray arrayWithArray:self.participants];
    [participants removeObject:callInfo];
    _participants = participants;
    
    for (int i = 0; i < self.participants.count; i++)
    {
        PJSIPCallInfo *part = self.participants[i];
        pjsua_conf_disconnect(callInfo.conf_port, part.conf_port);
        pjsua_conf_disconnect(part.conf_port, callInfo.conf_port);
    }
}

#pragma mark - private methods


@end
