//
//  UIImage+CV.h
//  TryHard
//
//  Created by Sergey on 6/17/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (Maintenance)

-(UIImage *)grayScaleImage;
-(UIImage *)blurredImage;
-(UIImage *)textDetect;
-(UIImage *)textDetectBetter;

@end
