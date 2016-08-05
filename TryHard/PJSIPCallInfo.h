//
//  PJSIPCallInfo.h
//  TryHard
//
//  Created by Sergei on 7/17/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "pjsua.h"

typedef enum
{
    /**
     * Call currently has no media, or the media is not used.
     */
    CALL_MEDIA_NONE,
    
    /**
     * The media is active
     */
    CALL_MEDIA_ACTIVE,
    
    /**
     * The media is currently put on hold by local endpoint
     */
    MEDIA_LOCAL_HOLD,
    
    /**
     * The media is currently put on hold by remote endpoint
     */
    CALL_MEDIA_REMOTE_HOLD,
    
    /**
     * The media has reported error (e.g. ICE negotiation)
     */
    CALL_MEDIA_ERROR
    
} MEDIA_STATUS;
//typedef pjsua_call_media_status MEDIA_STATUS;
typedef pjsip_status_code PJ_STATUS_CODE;

@interface PJSIPCallInfo : NSObject

@property (nonatomic, assign, readonly) int callID;
//make enum with roles
//@property (nonatomic, assign, readonly) int role;
@property (nonatomic, assign, readonly) int accID;
@property (nonatomic, assign, readonly) int conf_port;
@property (nonatomic, retain, readonly) NSString *localInfo;
@property (nonatomic, retain, readonly) NSString *localContact;
@property (nonatomic, retain, readonly) NSString *remoteInfo;
@property (nonatomic, retain, readonly) NSString *remoteContact;
//make struct with settings
//@property (nonatomic, assign, readonly) int settings;
//make struct with state
//@property (nonatomic, assign, readonly) int state;
@property (nonatomic, retain, readonly) NSString *stateText;
@property (nonatomic, readonly) PJ_STATUS_CODE lastStatus;
@property (nonatomic, retain, readonly) NSString *lastStatusText;
@property (nonatomic, readonly) MEDIA_STATUS mediaStatus;

-(id)initWithCallID:(int)callID;
@end
