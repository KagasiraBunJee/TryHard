//
//  UIImage+CV.m
//  TryHard
//
//  Created by Sergey on 6/17/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

#import "UIImage+CV.h"

#include  "opencv2/text.hpp"
#include "opencv2/core/utility.hpp"
#include "opencv2/imgproc.hpp"
#include "opencv2/imgcodecs.hpp"
#include "opencv2/highgui.hpp"
#include <opencv2/highgui/highgui_c.h>
#include <opencv2/opencv.hpp>
#include <stdio.h>

#include  <vector>
#include  <iostream>
#include  <iomanip>


using namespace cv;
using namespace std;
using namespace cv::text;

@implementation UIImage (Maintenance)

- (UIImage *)grayScaleImage
{
    Mat colorMatImage;
    colorMatImage =[self cvMatFromUIImage:self];
    
    Mat greyMatImage;
    cvtColor(colorMatImage, greyMatImage, COLOR_BGR2GRAY);

    return [self UIImageFromCVMat:greyMatImage];
    
}

- (UIImage *)blurredImage
{
    Mat colorMatImage = [self cvMatFromUIImage:self];
    
    Mat blurredMat;
    
//    for (int i = 1; i < 51; i=i+2)
//    {
//        medianBlur(colorMatImage, blurredMat, i);
//    }
    GaussianBlur(colorMatImage, blurredMat, cv::Size( 111, 111), 0, 0);
    
    return [self UIImageFromCVMat:blurredMat];
}

- (UIImage *)textDetectBetter
{
    Mat img1=[self cvMatFromUIImage:self];
    
    //Detect
    vector<cv::Rect> letterBBoxes1=detectLetters123(img1);
    //Display
    for(int i=0; i< letterBBoxes1.size(); i++)
        rectangle(img1,letterBBoxes1[i],cv::Scalar(0,255,0),3,8,0);
    
    return [self UIImageFromCVMat:img1];
}

- (UIImage *)textDetectBetterV2
{
    Mat img1=[self cvMatFromUIImage:self];
    Mat downscaled;
    pyrDown(img1, downscaled);
    Mat smallGrey;
    cvtColor(downscaled, smallGrey, CV_BGR2GRAY);
    Mat grad;
    Mat morphKernel = getStructuringElement(MORPH_ELLIPSE, cv::Size(3, 3));
    morphologyEx(smallGrey, grad, MORPH_GRADIENT, morphKernel);
    
    Mat bw;
    threshold(grad, bw, 0.0, 255.0, THRESH_BINARY | THRESH_OTSU);
    
    Mat connected;
    morphKernel = getStructuringElement(MORPH_RECT, cv::Size(9, 1));
    morphologyEx(bw, connected, MORPH_CLOSE, morphKernel);
    
    Mat mask = Mat::zeros(bw.size(), CV_8UC1);
    vector<vector<cv::Point>> contours;
    vector<Vec4i> hierarchy;
    findContours(connected, contours, hierarchy, CV_RETR_CCOMP, CV_CHAIN_APPROX_SIMPLE, cv::Point(0, 0));
    
    if (contours.size() > 0 )
    {
        for(int idx = 0; idx >= 0; idx = hierarchy[idx][0])
        {
            cv::Rect rect = boundingRect(contours[idx]);
            Mat maskROI(mask, rect);
            maskROI = Scalar(0, 0, 0);
            // fill the contour
            drawContours(mask, contours, idx, Scalar(255, 255, 255), CV_FILLED);
            // ratio of non-zero pixels in the filled region
            double r = (double)countNonZero(maskROI)/(rect.width*rect.height);
            
            if (r > .45
                &&
                (rect.height > 8 && rect.width > 8)
                )
            {
                rect.width *= 2;
                rect.height *=2;
                rect.y *= 2;
                rect.x *= 2;
                
                rectangle(img1, rect, Scalar(0, 255, 0), 2);
            }
        }
    }
    
    return [self UIImageFromCVMat:img1];
}

-(NSArray *)textBounds
{
    Mat img1=[self cvMatFromUIImage:self];
    
    //Detect
    vector<cv::Rect> letterBBoxes1=detectLetters123(img1);
    //Display
    NSMutableArray *arrays = [[NSMutableArray alloc]init];
    for(int i=0; i< letterBBoxes1.size(); i++)
    {
        cv::Rect rect = letterBBoxes1[i];
        CGRect textRect = CGRectMake(rect.x, rect.y, rect.width, rect.height);
        [arrays addObject:[NSValue valueWithCGRect:textRect]];
    }
    
    return arrays;
}

-(NSArray *)textBoundsV2
{
    Mat img1=[self cvMatFromUIImage:self];
    Mat downscaled;
    pyrDown(img1, downscaled);
    Mat smallGrey;
    cvtColor(downscaled, smallGrey, CV_BGR2GRAY);
    Mat grad;
    Mat morphKernel = getStructuringElement(MORPH_ELLIPSE, cv::Size(3, 3));
    morphologyEx(smallGrey, grad, MORPH_GRADIENT, morphKernel);
    
    Mat bw;
    threshold(grad, bw, 0.0, 255.0, THRESH_BINARY | THRESH_OTSU);
    
    Mat connected;
    morphKernel = getStructuringElement(MORPH_RECT, cv::Size(9, 1));
    morphologyEx(bw, connected, MORPH_CLOSE, morphKernel);
    
    Mat mask = Mat::zeros(bw.size(), CV_8UC1);
    vector<vector<cv::Point>> contours;
    vector<Vec4i> hierarchy;
    findContours(connected, contours, hierarchy, CV_RETR_CCOMP, CV_CHAIN_APPROX_SIMPLE, cv::Point(0, 0));
    
    NSMutableArray *arrays = [[NSMutableArray alloc]init];
    
    if (contours.size() > 0 )
    {
        for(int idx = 0; idx >= 0; idx = hierarchy[idx][0])
        {
            cv::Rect rect = boundingRect(contours[idx]);
            Mat maskROI(mask, rect);
            maskROI = Scalar(0, 0, 0);
            // fill the contour
            drawContours(mask, contours, idx, Scalar(255, 255, 255), CV_FILLED);
            // ratio of non-zero pixels in the filled region
            double r = (double)countNonZero(maskROI)/(rect.width*rect.height);
            
            if (r > .45 /* assume at least 45% of the area is filled if it contains text */
                &&
                (rect.height > 8 && rect.width > 8) /* constraints on region size */
                /* these two conditions alone are not very robust. better to use something
                 like the number of significant peaks in a horizontal projection as a third condition */
                )
            {
                rect.width *= 2;
                rect.height *=2;
                rect.y *= 2;
                rect.x *= 2;
                
                CGRect textRect = CGRectMake(rect.x, rect.y, rect.width, rect.height);
                [arrays addObject:[NSValue valueWithCGRect:textRect]];
                //            rectangle(img1, rect, Scalar(0, 255, 0), 2);
            }
        }
    }
    
    return arrays;
}

//MARK:- private methods
- (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}

- (Mat)cvMatGrayFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    Mat cvMat(rows, cols, CV_8UC1); // 8 bits per component, 1 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

- (Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

//MARK:- Helper methods

vector<cv::Rect> detectLetters123(cv::Mat img)
{
    std::vector<cv::Rect> boundRect;
    cv::Mat img_gray, img_sobel, img_threshold, element;
    cvtColor(img, img_gray, CV_BGR2GRAY);
    cv::Sobel(img_gray, img_sobel, CV_8U, 1, 0, 3, 1, 0, cv::BORDER_DEFAULT);
    cv::threshold(img_sobel, img_threshold, 0, 255, CV_THRESH_OTSU+CV_THRESH_BINARY);
    element = getStructuringElement(cv::MORPH_RECT, cv::Size(17, 3) );
    cv::morphologyEx(img_threshold, img_threshold, CV_MOP_CLOSE, element); //Does the trick
    std::vector< std::vector< cv::Point> > contours;
    cv::findContours(img_threshold, contours, 0, 1);
    std::vector<std::vector<cv::Point> > contours_poly( contours.size() );
    for( int i = 0; i < contours.size(); i++ )
        if (contours[i].size()>100)
        {
            cv::approxPolyDP( cv::Mat(contours[i]), contours_poly[i], 3, true );
            cv::Rect appRect( boundingRect( cv::Mat(contours_poly[i]) ));
            if (appRect.width>appRect.height)
                boundRect.push_back(appRect);
        }
    return boundRect;
}


@end
