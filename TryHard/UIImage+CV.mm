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

@interface UIImage()

- (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat;
- (Mat)cvMatGrayFromUIImage:(UIImage *)image;
- (Mat)cvMatFromUIImage:(UIImage *)image;

@end

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

- (UIImage *)textDetect
{
    
    cout << "Demo program of the Extremal Region Filter algorithm described in " << endl;
    cout << "Neumann L., Matas J.: Real-Time Scene Text Localization and Recognition, CVPR 2012" << endl << endl;
    
//    namedWindow("grouping",WINDOW_NORMAL);
    Mat src1 = [self cvMatFromUIImage:self];
    
    Mat src;
    cvtColor(src1,src,COLOR_RGBA2BGR);
    
    // Extract channels to be processed individually
    vector<Mat> channels;
    computeNMChannels(src, channels);
    
    int cn = (int)channels.size();
    // Append negative channels to detect ER- (bright regions over dark background)
    for (int c = 0; c < cn-1; c++)
        channels.push_back(255-channels[c]);
    
    // Create ERFilter objects with the 1st and 2nd stage default classifiers
    
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"trained_classifierNM1" ofType:@"xml"];
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"trained_classifierNM2" ofType:@"xml"];
    
    Ptr<ERFilter> er_filter1 = createERFilterNM1(loadClassifierNM1(path1.UTF8String),16,0.00015f,0.13f,0.2f,true,0.1f);
    Ptr<ERFilter> er_filter2 = createERFilterNM2(loadClassifierNM2(path2.UTF8String),0.5);
    
    vector<vector<ERStat> > regions(channels.size());
    // Apply the default cascade classifier to each independent channel (could be done in parallel)
    cout << "Extracting Class Specific Extremal Regions from " << (int)channels.size() << " channels ..." << endl;
    cout << "    (...) this may take a while (...)" << endl << endl;
    for (int c=0; c<(int)channels.size(); c++)
    {
        er_filter1->run(channels[c], regions[c]);
        er_filter2->run(channels[c], regions[c]);
    }
    
    // Detect character groups
    cout << "Grouping extracted ERs ... ";
    vector< vector<Vec2i> > region_groups;
    vector<cv::Rect> groups_boxes;
    erGrouping(src, channels, regions, region_groups, groups_boxes, ERGROUPING_ORIENTATION_HORIZ);
    //erGrouping(src, channels, regions, region_groups, groups_boxes, ERGROUPING_ORIENTATION_ANY, "./trained_classifier_erGrouping.xml", 0.5);
    
    // draw groups
    groups_draw(src, groups_boxes);
//    imshow("grouping",src);
    
    cout << "Done!" << endl << endl;
    cout << "Press 'e' to show the extracted Extremal Regions, any other key to exit." << endl << endl;
//    vector<Mat> rects = er_show(channels,regions);
//
//    NSMutableArray<UIImage *> *images;
//    
//    for (int c=0; c<(int)rects.size(); c++)
//    {
//        Mat rect = rects[c];
//        
//        UIImage *image = [self UIImageFromCVMat:rect];
//        
//        [images addObject:image];
//    }
//    
//    // memory clean-up
    er_filter1.release();
    er_filter2.release();
    regions.clear();
    if (!groups_boxes.empty())
    {
        groups_boxes.clear();
    }
    
    return [self UIImageFromCVMat:src];
}

- (UIImage *)textDetectBetter
{
    Mat img1=[self cvMatFromUIImage:self];
    
//    Mat img1;
//    cvtColor(img2, img1, COLOR_BGR2GRAY);
    
    //Detect
    vector<cv::Rect> letterBBoxes1=detectLetters(img1);
    //Display
    for(int i=0; i< letterBBoxes1.size(); i++)
        rectangle(img1,letterBBoxes1[i],cv::Scalar(0,255,0),3,8,0);
    
    return [self UIImageFromCVMat:img1];
}

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
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
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

void show_help_and_exit(const char *cmd)
{
    cout << "    Usage: " << cmd << " <input_image> " << endl;
    cout << "    Default classifier files (trained_classifierNM*.xml) must be in current directory" << endl << endl;
    exit(-1);
}

void groups_draw(Mat &src, vector<cv::Rect> &groups)
{
    for (int i=(int)groups.size()-1; i>=0; i--)
    {
        if (src.type() == CV_8UC3)
            rectangle(src,groups.at(i).tl(),groups.at(i).br(),Scalar( 0, 255, 255 ), 1, 4 );
        else
            rectangle(src,groups.at(i).tl(),groups.at(i).br(),Scalar( 255 ), 1, 4 );
    }
}

vector<Mat> er_show(vector<Mat> &channels, vector<vector<ERStat> > &regions)
{
    vector<Mat> rects((int)channels.size());
    for (int c=0; c<(int)channels.size(); c++)
    {
        Mat dst = Mat::zeros(channels[0].rows+2,channels[0].cols+2,CV_8UC1);
        for (int r=0; r<(int)regions[c].size(); r++)
        {
            ERStat er = regions[c][r];
            if (er.parent != NULL) // deprecate the root region
            {
                int newMaskVal = 255;
                int flags = 4 + (newMaskVal << 8) + FLOODFILL_FIXED_RANGE + FLOODFILL_MASK_ONLY;
                floodFill(channels[c],dst,cv::Point(er.pixel%channels[c].cols,er.pixel/channels[c].cols),
                          Scalar(255),0,Scalar(er.level),Scalar(0),flags);
            }
        }
        char buff[10]; char *buff_ptr = buff;
        sprintf(buff, "channel %d", c);
        
        rects.insert(rects.begin(), dst);
//        imshow(buff_ptr, dst);
    }
    return rects;
}

vector<cv::Rect> detectLetters(cv::Mat img)
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
