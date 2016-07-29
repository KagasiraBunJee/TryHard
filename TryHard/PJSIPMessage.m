//
//  PJSIPMessage.m
//  TryHard
//
//  Created by Sergey on 7/29/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

#import "PJSIPMessage.h"

@implementation PJSIPMessage

-(id)initWithSender:(NSString *)from to:(NSString *)to msg:(NSString *)msg
{
    self = [super init];
    if(self) {
        
        _from = from;
        _to = to;
        _msg = msg;
        _date = [NSDate date];
    }
    
    return self;
}

@end
