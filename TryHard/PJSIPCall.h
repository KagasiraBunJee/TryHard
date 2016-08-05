//
//  PJSIPCall.h
//  TryHard
//
//  Created by Sergey on 8/5/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PJSIPCall : NSObject

-(id)initWithID:(int)callID;

@property (nonatomic, assign, readonly) int callID;

@end
