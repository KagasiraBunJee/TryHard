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

@implementation THPJSipManager

+ (id) sharedManager
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
        
    }
    return self;
}

int startPjSip(char *sipUser, char* sipDomain)
{
    pj_status_t status;
    
    return 0;
}

@end
