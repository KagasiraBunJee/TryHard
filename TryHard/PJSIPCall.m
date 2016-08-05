//
//  PJSIPCall.m
//  TryHard
//
//  Created by Sergey on 8/5/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

#import "PJSIPCall.h"

@implementation PJSIPCall

-(id)initWithID:(int)callID
{
    self = [super init];
    if(self) {
        
        _callID = callID;
    }
    
    return self;
}

@end
