//
//  THPJSipManager.h
//  TryHard
//
//  Created by Sergey on 7/14/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol THPJSipManagerDelegate;

@protocol THPJSipManagerDelegate <NSObject>

@required
-(void)sipOnIncomingCall:(int)accId callId:(int) callId;
@optional
//optional methods

@end

@interface THPJSipManager : NSObject

@property (nonatomic, weak) id<THPJSipManagerDelegate> delegate;

+(THPJSipManager*) sharedManager;
-(void)registerUser:(NSString *)sipUser sipDomain:(NSString *)sipDomain;
-(void)callTo:(NSString *)sipUser;

@end
