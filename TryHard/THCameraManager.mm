//
//  THCameraManager.m
//  TryHard
//
//  Created by Sergey on 6/21/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

#import "THCameraManager.h"

#include  "opencv2/text.hpp"
#include "opencv2/core/utility.hpp"
#include "opencv2/imgproc.hpp"
#include "opencv2/imgcodecs.hpp"
#include "opencv2/highgui.hpp"
#include <opencv2/highgui/highgui_c.h>
#include <opencv2/opencv.hpp>
#import <opencv2/videoio/cap_ios.h>
#include <stdio.h>

#include  <vector>
#include  <iostream>
#include  <iomanip>


using namespace cv;
using namespace std;
using namespace cv::text;

@interface THCameraManager () <CvVideoCameraDelegate>
{
    CvVideoCamera* videoCamera;
}

@property (nonatomic, retain) CvVideoCamera* videoCamera;

@end

@implementation THCameraManager

-(id) initWithParentView: (UIView*) view
{
    self = [self init];
    
    self.videoCamera = [[CvVideoCamera alloc] initWithParentView:view];
    
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPresetLow;
    self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    self.videoCamera.defaultFPS = 30;
    self.videoCamera.grayscaleMode = NO;
    self.videoCamera.delegate = self;
    
    return self;
}

//- (id)init {
//    if (self = [super init]) {
//        
//    }
//    return self;
//}

-(void) setParentView:(UIView*) view
{
    self.videoCamera.parentView = view;
}

-(void) startSession
{
    [self.videoCamera start];
}

-(void) stopSession
{
    [self.videoCamera stop];
}

#pragma mark CvVideoCameraDelegate
-(void)processImage:(cv::Mat &)image
{
    //Detect
//    vector<cv::Rect> letterBBoxes1=detectLetters(image);
    //Display
//    for(int i=0; i< letterBBoxes1.size(); i++)
//        rectangle(image,letterBBoxes1[i],cv::Scalar(0,255,255),1,8,0);
    
//    Mat downscaled;
//    pyrDown(image, downscaled);
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
//    
//    if (contours.size() > 0 )
//    {
//        for(int idx = 0; idx >= 0; idx = hierarchy[idx][0])
//        {
//            cv::Rect rect = boundingRect(contours[idx]);
//            Mat maskROI(mask, rect);
//            maskROI = Scalar(0, 0, 0);
//            // fill the contour
//            drawContours(mask, contours, idx, Scalar(255, 255, 255), CV_FILLED);
//            // ratio of non-zero pixels in the filled region
//            double r = (double)countNonZero(maskROI)/(rect.width*rect.height);
//            
//            if (r > .45
//                &&
//                (rect.height > 8 && rect.width > 8)
//                )
//            {
//                rect.width *= 2;
//                rect.height *=2;
//                rect.y *= 2;
//                rect.x *= 2;
//                
//                rectangle(image, rect, Scalar(0, 255, 0), 2);
//            }
//        }
//    }
    
    //face
    
    vector<cv::Rect> detection_rois;
    
    const char *cascade_name = [[[NSBundle mainBundle] pathForResource:@"haarcascade_frontalface_default" ofType:@"xml"] cStringUsingEncoding:NSUTF8StringEncoding];
    CascadeClassifier haar_cascade;
    haar_cascade.load(cascade_name);
    haar_cascade.detectMultiScale(image, detection_rois, 1.2, 2,
                                  0|CV_HAAR_DO_CANNY_PRUNING);
    
    for(int i=0; i< detection_rois.size(); i++)
        rectangle(image,detection_rois[i],cv::Scalar(0,255,255),1,8,0);

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

void doMosaic(IplImage* in, int x0, int y0,
              int width, int height, int size)
{
    int b, g, r, col, row;
    
    int xMin = size*(int)floor((double)x0/size);
    int yMin = size*(int)floor((double)y0/size);
    int xMax = size*(int)ceil((double)(x0+width)/size);
    int yMax = size*(int)ceil((double)(y0+height)/size);
    
    for(int y=yMin; y<yMax; y+=size){
        for(int x=xMin; x<xMax; x+=size){
            b = g = r = 0;
            for(int i=0; i<size; i++){
                if( y+i > in->height ){
                    break;
                }
                row = i;
                for(int j=0; j<size; j++){
                    if( x+j > in->width ){
                        break;
                    }
                    b += (unsigned char)in->imageData[in->widthStep*(y+i)+(x+j)*3];
                    g += (unsigned char)in->imageData[in->widthStep*(y+i)+(x+j)*3+1];
                    r += (unsigned char)in->imageData[in->widthStep*(y+i)+(x+j)*3+2];
                    col = j;
                }
            }
            row++;
            col++;
            for(int i=0;i<row;i++){
                for(int j=0;j<col;j++){
                    in->imageData[in->widthStep*(y+i)+(x+j)*3]   = cvRound((double)b/(row*col));
                    in->imageData[in->widthStep*(y+i)+(x+j)*3+1] = cvRound((double)g/(row*col));
                    in->imageData[in->widthStep*(y+i)+(x+j)*3+2] = cvRound((double)r/(row*col));
                }
            }
        }
    }
}

@end
