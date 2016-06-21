//
//  THVideoHelper.m
//  TryHard
//
//  Created by Sergey on 6/20/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

#import "THVideoHelper.h"

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

@implementation THVideoHelper

+(CGImageRef) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer,0);        // Lock the image buffer
    
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0);   // Get information of the image
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef newImage = CGBitmapContextCreateImage(newContext);
    CGContextRelease(newContext);
    
    CGColorSpaceRelease(colorSpace);
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    return newImage;
}

+ (UIImage *)inspectVideoWithAddress:(void *)address width:(int) width height:(int) height
{
    
    Mat image;
    image.create(height, width, CV_8UC4);
    memcpy(image.data, address, width * height);

    Mat img1 = image.clone();
    
//    Mat downscaled;
//    pyrDown(img1, downscaled);
//    Mat smallGrey;
//    cvtColor(downscaled, smallGrey, CV_BGR2GRAY);
//    Mat grad;
//    Mat morphKernel = getStructuringElement(MORPH_ELLIPSE, cv::Size(3, 3));
//    morphologyEx(smallGrey, grad, MORPH_GRADIENT, morphKernel);
//    
//    Mat bw;
//    threshold(grad, bw, 0.0, 255.0, THRESH_BINARY | THRESH_OTSU);
//    
//    Mat connected;
//    morphKernel = getStructuringElement(MORPH_RECT, cv::Size(9, 1));
//    morphologyEx(bw, connected, MORPH_CLOSE, morphKernel);
//    
//    Mat mask = Mat::zeros(bw.size(), CV_8UC1);
//    vector<vector<cv::Point>> contours;
//    vector<Vec4i> hierarchy;
//    findContours(connected, contours, hierarchy, CV_RETR_CCOMP, CV_CHAIN_APPROX_SIMPLE, cv::Point(0, 0));
    
    return [THVideoHelper UIImageFromCVMat:image];
}

+ (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
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

+(NSData *) dataFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    void *src_buff = CVPixelBufferGetBaseAddress(imageBuffer);
    
    NSData *data = [NSData dataWithBytes:src_buff length:bytesPerRow * height];
    
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    return data;
}

+(UIImage *) sampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    
    CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    CVPixelBufferLockBaseAddress( pixelBuffer, 0 );
    
    int bufferWidth = CVPixelBufferGetWidth(pixelBuffer);
    int bufferHeight = CVPixelBufferGetHeight(pixelBuffer);
    
    int planes = CVPixelBufferGetPlaneCount(pixelBuffer);
    
    unsigned char *pixel = (unsigned char *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, planes-1);
    Mat image = cv::Mat(bufferHeight,bufferWidth,CV_8UC4,pixel); //put buffer in open cv, no memory copied
    //Processing here
    
    UIImage *img = [THVideoHelper UIImageFromCVMat:image];
    
//    Mat clone = image.clone();
    
    //End processing
    CVPixelBufferUnlockBaseAddress( pixelBuffer, 0 );
    
    return img;
}

+ (NSArray *)createIplImageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    IplImage *iplimage = 0;
    
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // get information of the image in the buffer
    uint8_t *bufferBaseAddress = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0);
    size_t bufferWidth = CVPixelBufferGetWidth(imageBuffer);
    size_t bufferHeight = CVPixelBufferGetHeight(imageBuffer);
    
    // create IplImage
    if (bufferBaseAddress) {
        iplimage = cvCreateImage(cvSize(bufferWidth, bufferHeight), IPL_DEPTH_8U, 4);
        iplimage->imageData = (char*)bufferBaseAddress;
    }
    
    Mat img1 = cvarrToMat(iplimage);
    
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
    
    if (contours.size() > 0)
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
            }
        }
    }
    
    // release memory
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    
    return arrays;
    
//    return iplimage;
}

+ (UIImage *)UIImageFromIplImage:(IplImage *)image {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // Allocating the buffer for CGImage
    NSData *data =
    [NSData dataWithBytes:image->imageData length:image->imageSize];
    CGDataProviderRef provider =
    CGDataProviderCreateWithCFData((CFDataRef)data);
    // Creating CGImage from chunk of IplImage
    CGImageRef imageRef = CGImageCreate(
                                        image->width, image->height,
                                        image->depth, image->depth * image->nChannels, image->widthStep,
                                        colorSpace, kCGImageAlphaNone|kCGBitmapByteOrderDefault,
                                        provider, NULL, false, kCGRenderingIntentDefault
                                        );
    // Getting UIImage from CGImage
    UIImage *ret = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    return ret;
}

@end
