//
//  PJSIPConference.h
//  TryHard
//
//  Created by Sergey on 8/5/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PJSIPCallInfo.h"

@interface PJSIPConference : NSObject

-(id)initWithCallInfo:(PJSIPCallInfo*)callInfo;

@property (nonatomic, assign, readonly) int id;
@property (nonatomic, readonly) PJSIPCallInfo *callInfo;
@property (nonatomic, retain, readonly) NSArray<PJSIPCallInfo*> *participants;

-(void)addParticipant:(PJSIPCallInfo*)callInfo;
-(void)removeParticipant:(PJSIPCallInfo*)callInfo;

@end
