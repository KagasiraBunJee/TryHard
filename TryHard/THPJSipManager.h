//
//  THPJSipManager.h
//  TryHard
//
//  Created by Sergey on 7/14/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THPJSIPDelegate.h"

@interface THPJSipManager : NSObject

@property (nonatomic, weak) id<THPJSipManagerDelegate> delegate;

+(THPJSipManager*) sharedManager;
-(void)registerUser:(NSString *)sipUser sipDomain:(NSString *)sipDomain;
-(void)callTo:(NSString *)sipUser;
-(void)answer:(int) call_id;
-(void)hangUp:(int) call_id;
-(void)holdCall:(int) call_id;
-(void)unholdCall:(int) call_id;

@end
