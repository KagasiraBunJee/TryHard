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
    pjsua_config app_cfg;
    NSString *out_bound_proxy;
    NSString *out_bound_proxy_port;
}

@property pj_status_t status;

@end

@implementation THPJSipManager

THPJSipManager *manager;
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

- (id)initWithOutboundProxy:(NSString*)outboundProxy port:(NSString*)port
{
    out_bound_proxy = outboundProxy;
    out_bound_proxy_port = port;
    self = [super init];
    if(self) {
        [self initPjSua];
        [self initUDPPjSuaTransport];
        [self initTCPPjSuaTransport];
        [self startPjSip];
        
        _calls = 0;
        _incomingCalls = 0;
        
        manager = self;
    }
    return self;
}

- (id)init {
    if (self = [super init]) {
        
        [self initPjSua];
        [self initUDPPjSuaTransport];
        [self initTCPPjSuaTransport];
        [self startPjSip];
        
//        pjsip_resolver_t *resolver;
//        
//        pj_caching_pool cp;
//        pj_caching_pool_init(&cp, NULL, 1024*1024);
//        
//        pj_pool_t *pool;
//        pool = pj_pool_create(&cp.factory, "resolver_pool", 4000, 4000, NULL);
//        
//        pjsip_resolver_create(pool, &resolver);
//        
//        pjsip_host_info host;
//        host.flag = PJSIP_TRANSPORT_DATAGRAM;
//        host.type = PJSIP_TRANSPORT_UDP;
//        host.addr.host = pj_str((char *)"sip2sip.info");
//        host.addr.port = 5060;
//        
//        void *token = NULL;
//        
//        pjsip_resolve(resolver, pool, &host, token, resolver_cb_func);
        
        _calls = 0;
        _incomingCalls = 0;
        
        manager = self;
    }
    return self;
}

-(void)registerUser:(PJSIPCredention *)cred userInfo:(void* ) userInfo
{
    pjsua_acc_id acc_id;
    pjsua_acc_config cfg;
    pjsua_acc_config_default(&cfg);
    
    char sipId[MAX_SIP_ID_LENGTH];
    sprintf(sipId, "sip:%s@%s:5060", [cred.username UTF8String], [cred.realm UTF8String]);
    cfg.id = pj_str(sipId);
    
    char regUri[MAX_SIP_REG_URI_LENGTH];
    sprintf(regUri, "sip:%s", [cred.realm UTF8String]);
    
    cfg.reg_uri = pj_str(regUri);
    cfg.vid_out_auto_transmit = hasVideoSupport();
    cfg.vid_in_auto_show = hasVideoSupport();
    
    cfg.cred_count = 1;
    cfg.cred_info[0].username = pj_str((char *)[cred.username UTF8String]);
    cfg.cred_info[0].realm = pj_str((char *)[cred.realm UTF8String]);
    cfg.cred_info[0].data_type = (int)cred.dataType;
    cfg.cred_info[0].data = pj_str((char *)[cred.data UTF8String]);
    cfg.cred_info[0].scheme = pj_str((char *)[cred.scheme UTF8String]);
    
    // 2. Register the account
    status = pjsua_acc_add(&cfg, PJ_TRUE, &acc_id);
    if (status != PJ_SUCCESS) error("Error registering acc", status);
}

-(void)callTo:(NSString *)sipUser withVideo:(BOOL) withVideo
{
    char regUri[MAX_SIP_REG_URI_LENGTH];
    sprintf(regUri, "sip:%s", [sipUser UTF8String]);
    pj_str_t uri = pj_str(regUri);
    
    
    pjsua_call_setting callCfg;
    pjsua_call_setting_default(&callCfg);
    callCfg.vid_cnt = 1;
    if (withVideo == NO || hasVideoSupport() == PJ_FALSE)
    {
        callCfg.vid_cnt = 0;
    }
    
    self.status = pjsua_call_make_call(currentAccount, &uri, &callCfg, NULL, NULL, NULL);
    if (self.status != PJ_SUCCESS) error("Error making call", status);
}

-(void)answer:(int) call_id withVideo:(BOOL) withVideo
{
    pjsua_call_setting callCfg;
    pjsua_call_setting_default(&callCfg);
    callCfg.vid_cnt = 1;
    
    if (withVideo == NO || hasVideoSupport() == PJ_FALSE)
    {
        callCfg.vid_cnt = 0;
    }
    
    pjsua_call_answer2(call_id, &callCfg, 200, NULL, NULL);
}

-(void)busy:(int)call_id withMessage:(NSString*)message
{
    [self hangUp:call_id reasonCode:603 reasonMsg:message];
}

-(void)hangUp:(int) call_id withMessage:(NSString*)message
{
    [self hangUp:call_id reasonCode:200 reasonMsg:message];
}

-(void)hangUp:(int)call_id reasonCode:(int)reasonCode reasonMsg:(NSString *)reasonMsg
{
    pj_str_t reason = pj_str((char *)[reasonMsg UTF8String]);
    pjsua_call_hangup(call_id, reasonCode, &reason, NULL);
}

-(void)hangUpAll
{
    pjsua_call_hangup_all();
}

-(void)holdCall:(int)call_id
{
    pjsua_call_set_hold(call_id, NULL);
}

-(void)unholdCall:(int)call_id
{
    pjsua_call_reinvite(call_id, PJSUA_CALL_UNHOLD, NULL);
}

-(NSData*)getAccInfo:(int)acc_id
{
    void * data = pjsua_acc_get_user_data(acc_id);
    
    NSData *nsdata = [NSData dataWithBytes:data length:sizeof(data)];
    return nsdata;
}

#pragma mark - setting up methods
-(void)initPjSua
{
    status = pjsua_create();
    if (status != PJ_SUCCESS) error("Error in pjsua_create()", status);
    
    pjsua_config_default (&app_cfg);
    
    app_cfg.cb.on_incoming_call = &on_incoming_call;
    app_cfg.cb.on_call_media_state = &on_call_media_state;
    app_cfg.cb.on_call_state = &on_call_state;
    app_cfg.cb.on_reg_state2 = &on_reg_state2;
    app_cfg.cb.on_call_media_event = &on_call_media_event;
    
    if (![out_bound_proxy isEqualToString:@""])
    {
        char proxy[MAX_SIP_REG_URI_LENGTH];
        sprintf(proxy, "sip:%s:%s", [out_bound_proxy UTF8String], [out_bound_proxy_port UTF8String]);
        app_cfg.outbound_proxy_cnt = 1;
        app_cfg.outbound_proxy[0] = pj_str((char *)proxy);
    }

    pjsua_logging_config log_cfg;
    pjsua_logging_config_default(&log_cfg);
    log_cfg.console_level = 4;
    
    status = pjsua_init(&app_cfg, &log_cfg, NULL);
    if (status != PJ_SUCCESS) error("Error in pjsua_init()", status);
}

-(void)initUDPPjSuaTransport
{
    pjsua_transport_config cfg;
    pjsua_transport_config_default(&cfg);
    cfg.port = 5090;
    
    status = pjsua_transport_create(PJSIP_TRANSPORT_UDP, &cfg, NULL);
    if (status != PJ_SUCCESS) error("Error creating transport", status);
}

-(void)initTCPPjSuaTransport
{
    pjsua_transport_config cfg;
    pjsua_transport_config_default(&cfg);
    cfg.port = 5090;
    
    // Add TCP transport.
    status = pjsua_transport_create(PJSIP_TRANSPORT_TCP, &cfg, NULL);
    if (status != PJ_SUCCESS) error("Error creating transport", status);
}

-(void)startPjSip
{
    pj_str_t pro = pj_str((char *)"H263-1998/96");
    pjsua_vid_codec_set_priority(&pro,255);
    
    status = pjsua_start();
    if (status != PJ_SUCCESS) error("Error starting pjsua", status);
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:[UIDevice currentDevice]];
}

- (void)orientationChanged:(NSNotification *)note
{
    const pjmedia_orient pj_ori[4] =
    {
        PJMEDIA_ORIENT_ROTATE_90DEG,  /* UIDeviceOrientationPortrait */
        PJMEDIA_ORIENT_ROTATE_270DEG, /* UIDeviceOrientationPortraitUpsideDown */
        PJMEDIA_ORIENT_ROTATE_180DEG, /* UIDeviceOrientationLandscapeLeft,
                                       home button on the right side */
        PJMEDIA_ORIENT_NATURAL        /* UIDeviceOrientationLandscapeRight,
                                       home button on the left side */
    };
    static pj_thread_desc a_thread_desc;
    static pj_thread_t *a_thread;
    static UIDeviceOrientation prev_ori;
    UIDeviceOrientation dev_ori = [[UIDevice currentDevice] orientation];
    int i;
    
    if (dev_ori == prev_ori) return;
    
    NSLog(@"Device orientation changed: %d", (prev_ori = dev_ori));
    
    if (dev_ori >= UIDeviceOrientationPortrait &&
        dev_ori <= UIDeviceOrientationLandscapeRight)
    {
        if (!pj_thread_is_registered()) {
            pj_thread_register("ipjsua", a_thread_desc, &a_thread);
        }
        
        /* Here we set the orientation for all video devices.
         * This may return failure for renderer devices or for
         * capture devices which do not support orientation setting,
         * we can simply ignore them.
         */
        for (i = pjsua_vid_dev_count()-1; i >= 0; i--) {
            pjsua_vid_dev_set_setting(i, PJMEDIA_VID_DEV_CAP_ORIENTATION,
                                      &pj_ori[dev_ori-1], PJ_TRUE);
        }
    }
}

#pragma mark - help methods
static pj_bool_t hasVideoSupport()
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        return PJ_TRUE;
    
    return PJ_FALSE;
}

static void error(const char *title, pj_status_t status)
{
    pjsua_perror(THIS_FILE, title, status);
    pjsua_destroy();
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
    
    if (manager.delegate && [manager.delegate respondsToSelector:@selector(pjsip_onIncomingCall:callInfo:)])
    {
        PJSIPCallInfo* info = [[PJSIPCallInfo alloc] initWithCallID:call_id];
        [manager.delegate pjsip_onIncomingCall:call_id callInfo:info];
    }
    
    NSLog(@"call incoming");
}

/* Callback called by the library when call's state has changed */
static void on_call_state(pjsua_call_id call_id, pjsip_event *e)
{
    pjsua_call_info ci;
    
    PJ_UNUSED_ARG(e);
    
    pjsua_call_get_info(call_id, &ci);
    PJ_LOG(3,(THIS_FILE, "on_call_state() Call %d state=%.*s", call_id,
              (int)ci.state_text.slen,
              ci.state_text.ptr));
    
    if (manager.delegate)
    {
        PJSIPCallInfo* info = [[PJSIPCallInfo alloc] initWithCallID:call_id];
        if (ci.state == PJSIP_INV_STATE_CONFIRMED && [manager.delegate respondsToSelector:@selector(pjsip_onCallDidConfirm:callInfo:)])
        {
            [manager.delegate pjsip_onCallDidConfirm:call_id callInfo:info];
        }
        else if (ci.state == PJSIP_INV_STATE_CALLING && [manager.delegate respondsToSelector:@selector(pjsip_onCallOnCalling:callInfo:)])
        {
            [manager.delegate pjsip_onCallOnCalling:call_id callInfo:info];
        }
        else if (ci.state == PJSIP_INV_STATE_DISCONNECTED && [manager.delegate respondsToSelector:@selector(pjsip_onCallDidHangUp:callInfo:)])
        {
            [manager.delegate pjsip_onCallDidHangUp:call_id callInfo:info];
        }
    }
    
}

/* Callback called by the library when call's media state has changed */
static void on_call_media_state(pjsua_call_id call_id)
{
    pjsua_call_info ci;
    
    pjsua_call_get_info(call_id, &ci);
    
    PJ_LOG(3,(THIS_FILE, "on_call_media_state() Call %d media state=%.*s", call_id,
              (int)ci.state_text.slen,
              ci.state_text.ptr));
    
    if (ci.media_status == PJSUA_CALL_MEDIA_ACTIVE) {
        // When media is active, connect call to sound device.
        pjsua_conf_connect(ci.conf_slot, 0);
        pjsua_conf_connect(0, ci.conf_slot);
    }
    
    
}

static void on_call_media_event(pjsua_call_id call_id, unsigned med_idx, pjmedia_event *event)
{
    if (event->type == PJMEDIA_EVENT_FMT_CHANGED) {
        /* Adjust renderer window size to original video size */
        pjsua_call_info ci;
        
        pjsua_call_get_info(call_id, &ci);
        
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        {
            if ((ci.media[med_idx].type == PJMEDIA_TYPE_VIDEO) &&
                (ci.media[med_idx].dir & PJMEDIA_DIR_DECODING))
            {
                pjsua_vid_win_id wid;
                pjmedia_rect_size size;
                pjsua_vid_win_info win_info;
                
                wid = ci.media[med_idx].stream.vid.win_in;
                pjsua_vid_win_get_info(wid, &win_info);
                
                size = event->data.fmt_changed.new_fmt.det.vid.size;
                if (size.w != win_info.size.w || size.h != win_info.size.h) {
                    pjsua_vid_win_set_size(wid, &size);
                    
                    /* Re-arrange video windows */
                    
                    int vid_idx;
                    pjsua_vid_win_id wid;
                    
                    vid_idx = pjsua_call_get_vid_stream_idx(call_id);
                    pj_bool_t videoRunning = pjsua_call_vid_stream_is_running(call_id, vid_idx, ci.media_dir);
                    if (vid_idx >= 0 && videoRunning == PJ_TRUE) {
                        
                        wid = ci.media[vid_idx].stream.vid.win_in;
                        
                        pjsua_vid_win_info vid_info;
                        pj_status_t status = pjsua_vid_win_get_info(wid, &vid_info);
                        
                        pjmedia_coord pos;
                        int i, last;
                        
                        pos.x = 0;
                        pos.y = 10;
                        last = (wid == PJSUA_INVALID_ID) ? PJSUA_MAX_VID_WINS : wid;
                        
                        for (i=0; i<last; ++i) {
                            pjsua_vid_win_info wi;
                            pj_status_t status;
                            
                            status = pjsua_vid_win_get_info(i, &wi);
                            if (status != PJ_SUCCESS)
                                continue;
                            
                            if (wid == PJSUA_INVALID_ID)
                                pjsua_vid_win_set_pos(i, &pos);
                            
                            if (wi.show)
                                pos.y += wi.size.h;
                        }
                        
                        if (wid != PJSUA_INVALID_ID)
                            pjsua_vid_win_set_pos(wid, &pos);
                        
                        if (status == PJ_SUCCESS)
                        {
                            UIView *parent = manager.videoView;
                            UIView *view = (__bridge UIView *)vid_info.hwnd.info.ios.window;
                            
                            if (view) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    /* Add the video window as subview */
                                    if (![view isDescendantOfView:parent])
                                        [parent addSubview:view];
                                    
                                    if (!vid_info.is_native) {
                                        /* Resize it to fit width */
                                        view.bounds = CGRectMake(0, 0, parent.bounds.size.width,
                                                                 (parent.bounds.size.height *
                                                                  1.0*parent.bounds.size.width/
                                                                  view.bounds.size.width));
                                        /* Center it horizontally */
                                        view.center = CGPointMake(parent.bounds.size.width/2.0,
                                                                  view.bounds.size.height/2.0);
                                    } else {
                                        /* Preview window, move it to the bottom */
                                        view.center = CGPointMake(parent.bounds.size.width/2.0,
                                                                  parent.bounds.size.height-
                                                                  view.bounds.size.height/2.0);
                                    }
                                });
                            }
                        }
                    }
                }
            }
        }
    }
}

static void on_reg_state2(pjsua_acc_id acc_id, pjsua_reg_info *info)
{
    PJ_LOG(3,(THIS_FILE, "on_reg_state2() Register acc %d", acc_id));
    if (manager.delegate)
    {
        if (info->renew == PJ_TRUE && info->cbparam->code == 200 && [manager.delegate respondsToSelector:@selector(pjsip_onAccountRegistered:)])
        {
            [manager.delegate pjsip_onAccountRegistered:acc_id];
        }
        
        if (info->renew == PJ_TRUE && [manager.delegate respondsToSelector:@selector(pjsip_onAccountRegisterStateChanged:statusCode:)])
        {
            [manager.delegate pjsip_onAccountRegisterStateChanged:acc_id statusCode:info->cbparam->code];
        }
    }
}

//static void resolver_cb_func(pj_status_t status, void *token, const struct pjsip_server_addresses *addr)
//{
//    const pjsip_server_addresses addrs = addr[0];
//    
//    unsigned char bytes[4];
//    bytes[0] = addrs.entry[0].addr.ipv4.sin_addr.s_addr & 0xFF;
//    bytes[1] = (addrs.entry[0].addr.ipv4.sin_addr.s_addr >> 8) & 0xFF;
//    bytes[2] = (addrs.entry[0].addr.ipv4.sin_addr.s_addr >> 16) & 0xFF;
//    bytes[3] = (addrs.entry[0].addr.ipv4.sin_addr.s_addr >> 24) & 0xFF;
//    
//    
//    NSLog(@"%d.%d.%d.%d\n", bytes[3], bytes[2], bytes[1], bytes[0]);
//}

@end
