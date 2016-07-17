//
//  THCommandListener.h
//  TryHard
//
//  Created by Sergey on 7/1/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THCommandListener : NSObject

+(THCommandListener *)sharedManager;
-(void) parseCommand:(NSString*) file;

@end
