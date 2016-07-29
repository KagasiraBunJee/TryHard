//
//  PJSIPMessage.h
//  TryHard
//
//  Created by Sergey on 7/29/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PJSIPMessage : NSObject

@property (nonatomic, retain, readonly) NSString *from;
@property (nonatomic, retain, readonly) NSString *to;
@property (nonatomic, retain, readonly) NSString *msg;
@property (nonatomic, assign, readonly) NSDate *date;

-(id)initWithSender:(NSString *)from to:(NSString *) to msg:(NSString *) msg;

@end
