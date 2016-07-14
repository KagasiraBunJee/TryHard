//
//  THCommandListener.m
//  TryHard
//
//  Created by Sergey on 7/1/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

#import "THCommandListener.h"

#include <pocketsphinx/pocketsphinx.h>

@interface THCommandListener () {
    ps_decoder_t *ps;
    cmd_ln_t *config;
}

@property (nonatomic, retain) NSString *someProperty;

@end

@implementation THCommandListener

+ (THCommandListener *)sharedManager {
    
    static THCommandListener *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        
        ps = NULL;
        config = NULL;
        
        NSString *modelPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"model"];
        NSString *musicFile = [[NSBundle mainBundle] pathForResource:@"goforward" ofType:@"raw"];
        
        const char *usFolderPath = [[modelPath stringByAppendingString:@"/en-us/en-us"] cStringUsingEncoding:NSUTF8StringEncoding];
        const char *uslmbinfile = [[modelPath stringByAppendingString:@"/en-us/en-us.lm.bin"] cStringUsingEncoding:NSUTF8StringEncoding];
        const char *uscmudictfile = [[modelPath stringByAppendingString:@"/en-us/cmudict-en-us.dict"] cStringUsingEncoding:NSUTF8StringEncoding];
        
        config = cmd_ln_init(NULL, ps_args(), TRUE,
                             "-hmm", usFolderPath,
                             "-lm", uslmbinfile,
                             "-dict", uscmudictfile,
                             NULL);
        if (config == NULL)
        {
            NSLog(@"Error to create config object");
        }
        
        ps = ps_init(config);
        
        if (ps == NULL)
        {
            NSLog(@"Failed to create recognizer");
        }
    }
    return self;
}

-(void)parseCommand:(NSString *)file
{
    
    FILE *fh;
    char const *hyp, *uttid;
    int16 buf[512];
    int rv;
    int32 score;

    fh = fopen([file cStringUsingEncoding:NSUTF8StringEncoding], "rb");
    
    if (fh == NULL)
    {
        NSLog(@"Failed to open file");
        return;
    }
    
    rv = ps_start_utt(ps);
    
    while (!feof(fh)) {
        size_t nsamp;
        nsamp = fread(buf, 2, 512, fh);
        rv = ps_process_raw(ps, buf, nsamp, FALSE, FALSE);
    }
    
    rv = ps_end_utt(ps);
    hyp = ps_get_hyp(ps, &score);
    NSLog(@"Recognized: %s", hyp);
    
    fclose(fh);
//    ps_free(ps);
//    cmd_ln_free_r(config);
}

@end
