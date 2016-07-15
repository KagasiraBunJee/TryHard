//
//  THPJSipManager.m
//  TryHard
//
//  Created by Sergey on 7/14/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

#import "THPJSipManager.h"
#include <pjsua-lib/pjsua.h>
#define THIS_FILE "THPJSipManager.m"

@interface THPJSipManager ()
{
    pj_status_t status;
    pjsua_acc_id currentAccount;
}

@property pj_status_t status;

@end

@implementation THPJSipManager

const size_t MAX_SIP_ID_LENGTH = 50;
const size_t MAX_SIP_REG_URI_LENGTH = 50;

@synthesize status;

+ (THPJSipManager*) sharedManager
{
    static THPJSipManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init {
    if (self = [super init]) {
        
        [self initPjSua];
        [self initUDPPjSuaTransport];
        [self initTCPPjSuaTransport];
        [self startPjSip];
    }
    return self;
}

-(void)registerUser:(NSString *)sipUser sipDomain:(NSString *)sipDomain
{
    currentAccount = registerAcc(status, sipUser, sipDomain);
    if (status != PJ_SUCCESS) error("Error adding account", status);
}

#pragma mark - setting up methods
-(void)initPjSua
{
    
    status = pjsua_create();
    if (status != PJ_SUCCESS) error("Error in pjsua_create()", status);
    
    pjsua_config cfg;
    pjsua_config_default (&cfg);
    
    cfg.cb.on_incoming_call = &on_incoming_call;
    cfg.cb.on_call_media_state = &on_call_media_state;
    cfg.cb.on_call_state = &on_call_state;
    
    pjsua_logging_config log_cfg;
    pjsua_logging_config_default(&log_cfg);
    log_cfg.console_level = 4;
    
    status = pjsua_init(&cfg, &log_cfg, NULL);
    if (status != PJ_SUCCESS) error("Error in pjsua_init()", status);
}

-(void)initUDPPjSuaTransport
{
    pjsua_transport_config cfg;
    pjsua_transport_config_default(&cfg);
    cfg.port = 5080;
    
    status = pjsua_transport_create(PJSIP_TRANSPORT_UDP, &cfg, NULL);
    if (status != PJ_SUCCESS) error("Error creating transport", status);
}

-(void)initTCPPjSuaTransport
{
    pjsua_transport_config cfg;
    pjsua_transport_config_default(&cfg);
    cfg.port = 5080;
    
    // Add TCP transport.
    status = pjsua_transport_create(PJSIP_TRANSPORT_TCP, &cfg, NULL);
    if (status != PJ_SUCCESS) error("Error creating transport", status);
}

-(void)startPjSip
{
    status = pjsua_start();
    if (status != PJ_SUCCESS) error("Error starting pjsua", status);
}

#pragma mark - help methods
static void error(const char *title, pj_status_t status)
{
    pjsua_perror(THIS_FILE, title, status);
    pjsua_destroy();
}

static pjsua_acc_id registerAcc(pj_status_t &status, NSString* sipUser, NSString* sipDomain)
{
    pjsua_acc_id acc_id;
    pjsua_acc_config cfg;
    pjsua_acc_config_default(&cfg);
    
    char sipId[MAX_SIP_ID_LENGTH];
    sprintf(sipId, "sip:%s@%s", [sipUser UTF8String], [sipDomain UTF8String]);
    cfg.id = pj_str(sipId);
    
    char regUri[MAX_SIP_REG_URI_LENGTH];
    sprintf(regUri, "sip:%s", [sipDomain UTF8String]);
    
    cfg.reg_uri = pj_str(regUri);
    
    // 2. Register the account
    status = pjsua_acc_add(&cfg, PJ_TRUE, &acc_id);
    
    return acc_id;
}

- (void)callTo:(NSString *)sipUser
{
    char regUri[MAX_SIP_REG_URI_LENGTH];
    sprintf(regUri, "sip:%s", [sipUser UTF8String]);
    pj_str_t uri = pj_str(regUri);
    
    self.status = pjsua_call_make_call(currentAccount, &uri, 0, NULL, NULL, NULL);
    if (self.status != PJ_SUCCESS) error("Error making call", status);
}

#pragma mark - Callback for pjsip

/* Callback called by the library upon receiving incoming call */
void on_incoming_call(pjsua_acc_id acc_id, pjsua_call_id call_id,
                             pjsip_rx_data *rdata)
{
    // 1. Get caller info
    pjsua_call_info ci;
    
    PJ_UNUSED_ARG(acc_id);
    PJ_UNUSED_ARG(rdata);
    
    pjsua_call_get_info(call_id, &ci);
    
    PJ_LOG(3,(THIS_FILE, "Incoming call from %.*s!!",
              (int)ci.remote_info.slen,
              ci.remote_info.ptr));
    
    
    NSLog(@"call incoming");
    // 2. Answer the call
    /* Automatically answer incoming calls with 200/OK */
//    pjsua_call_answer(call_id, 200, NULL, NULL);
}

/* Callback called by the library when call's state has changed */
static void on_call_state(pjsua_call_id call_id, pjsip_event *e)
{
    pjsua_call_info ci;
    
    PJ_UNUSED_ARG(e);
    
    pjsua_call_get_info(call_id, &ci);
    PJ_LOG(3,(THIS_FILE, "Call %d state=%.*s", call_id,
              (int)ci.state_text.slen,
              ci.state_text.ptr));
}

/* Callback called by the library when call's media state has changed */
static void on_call_media_state(pjsua_call_id call_id)
{
    pjsua_call_info ci;
    
    pjsua_call_get_info(call_id, &ci);
    
    if (ci.media_status == PJSUA_CALL_MEDIA_ACTIVE) {
        // When media is active, connect call to sound device.
        pjsua_conf_connect(ci.conf_slot, 0);
        pjsua_conf_connect(0, ci.conf_slot);
    }
}

@end
