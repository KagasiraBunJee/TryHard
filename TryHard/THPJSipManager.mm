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

- (id)init {
    if (self = [super init]) {
        
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

-(void)registerUser:(NSString *)sipUser sipDomain:(NSString *)sipDomain
{
    currentAccount = registerAcc(status, sipUser, sipDomain);
    if (status != PJ_SUCCESS) error("Error adding account", status);
}

-(void)callTo:(NSString *)sipUser withVideo:(BOOL) withVideo
{
    char regUri[MAX_SIP_REG_URI_LENGTH];
    sprintf(regUri, "sip:%s", [sipUser UTF8String]);
    pj_str_t uri = pj_str(regUri);
    
    
    pjsua_call_setting callCfg;
    pjsua_call_setting_default(&callCfg);
    callCfg.vid_cnt = 1;
    if (withVideo == NO || [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
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
    
    if (withVideo == NO || [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        callCfg.vid_cnt = 0;
    }
    
    pjsua_call_answer2(call_id, &callCfg, 200, NULL, NULL);
}

-(void)hangUp:(int)call_id
{
    pjsua_call_hangup(call_id, 200, NULL, NULL);
}

-(void)holdCall:(int)call_id
{
    pjsua_call_set_hold(call_id, NULL);
}

-(void)unholdCall:(int)call_id
{
    pjsua_call_reinvite(call_id, PJSUA_CALL_UNHOLD, NULL);
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
    cfg.cb.on_reg_state2 = &on_reg_state2;
    cfg.cb.on_call_media_event = &on_call_media_event;
    
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
    cfg.vid_out_auto_transmit = PJ_TRUE;
    cfg.vid_in_auto_show = PJ_TRUE;
    
    // 2. Register the account
    status = pjsua_acc_add(&cfg, PJ_TRUE, &acc_id);
    if (status != PJ_SUCCESS) error("Error registering acc", status);
    
    char codec[MAX_SIP_ID_LENGTH];
    sprintf(sipId, "%s", "H263-1998/96");
    pj_str_t pro = pj_str(codec);
    pjsua_vid_codec_set_priority(&pro,255);
    
    
    return acc_id;
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
    
    if (manager.delegate && [manager.delegate respondsToSelector:@selector(sipOnIncomingCall:callInfo:)])
    {
        PJSIPCallInfo* info = [[PJSIPCallInfo alloc] initWithCallID:call_id];
        [manager.delegate sipOnIncomingCall:call_id callInfo:info];
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
        if (ci.state == PJSIP_INV_STATE_CONFIRMED && [manager.delegate respondsToSelector:@selector(sipOnCallDidConfirm:callInfo:)])
        {
            [manager.delegate sipOnCallDidConfirm:call_id callInfo:info];
        }
        else if (ci.state == PJSIP_INV_STATE_CALLING && [manager.delegate respondsToSelector:@selector(sipOnCallOnCalling:callInfo:)])
        {
            [manager.delegate sipOnCallOnCalling:call_id callInfo:info];
        }
        else if (ci.state == PJSIP_INV_STATE_DISCONNECTED && [manager.delegate respondsToSelector:@selector(sipOnCallDidHangUp:callInfo:)])
        {
            [manager.delegate sipOnCallDidHangUp:call_id callInfo:info];
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
#if PJSUA_HAS_VIDEO
    if (event->type == PJMEDIA_EVENT_FMT_CHANGED) {
        /* Adjust renderer window size to original video size */
        pjsua_call_info ci;
        
        pjsua_call_get_info(call_id, &ci);
        
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
#else
    PJ_UNUSED_ARG(call_id);
    PJ_UNUSED_ARG(med_idx);
    PJ_UNUSED_ARG(event);
#endif
}

static void on_reg_state2(pjsua_acc_id acc_id, pjsua_reg_info *info)
{
    PJ_LOG(3,(THIS_FILE, "on_reg_state2() Register acc %d", acc_id));
    int accs = pjsua_acc_get_count();
    NSLog(@"Accounts count: %i", accs);
}

@end
