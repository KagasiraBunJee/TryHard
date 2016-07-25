//
//  PJSIPCredention.h
//  TryHard
//
//  Created by Sergey on 7/21/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PJSIP_CRED_TYPE) {
    PJSIP_CRED_TYPE_PLAIN_PASSWORD = 0,
    PJSIP_CRED_TYPE_DIGEST = 1,
    PJSIP_CRED_TYPE_EXT_AKA = 16
};

@interface PJSIPCredention : NSObject

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *nickname;
@property (nonatomic, retain) NSString *realm;
@property (nonatomic, retain) NSString *address;
@property PJSIP_CRED_TYPE dataType;
@property (nonatomic, retain) NSString *data;
@property (nonatomic, retain) NSString *scheme;
@property (nonatomic, retain) NSString *proxy;

@end
