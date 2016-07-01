//
//  THImageFilter.m
//  TryHard
//
//  Created by Sergey on 6/21/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

#import "THImageFilter.h"

#include  "opencv2/text.hpp"
#include "opencv2/core/utility.hpp"
#include "opencv2/imgproc.hpp"
#include "opencv2/imgcodecs.hpp"
#include "opencv2/highgui.hpp"
#include <opencv2/highgui/highgui_c.h>
#include <opencv2/opencv.hpp>
#include <stdio.h>

#include <pocketsphinx/pocketsphinx.h>

#include  <vector>
#include  <iostream>
#include  <iomanip>

#define MODELDIR "c:/sphinx/model"

using namespace cv;
using namespace std;
using namespace cv::text;

@implementation THImageFilter



+(void)config
{
    ps_decoder_t *ps = NULL;
    cmd_ln_t *config = NULL;

    FILE *fh;
    char const *hyp, *uttid;
    int16 buf[512];
    int rv;
    int32 score;
    
    NSString *modelPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"model"];
    NSString *musicFile = [[NSBundle mainBundle] pathForResource:@"goforward" ofType:@"raw"];
    
    const char *usFolderPath = [[modelPath stringByAppendingString:@"/en-us/en-us"] cStringUsingEncoding:NSUTF8StringEncoding];
    const char *uslmbinfile = [[modelPath stringByAppendingString:@"/en-us/en-us.lm.bin"] cStringUsingEncoding:NSUTF8StringEncoding];
    const char *uscmudictfile = [[modelPath stringByAppendingString:@"/en-us/cmudict-en-us.dict"] cStringUsingEncoding:NSUTF8StringEncoding];
    
    config = cmd_ln_init(NULL, ps_args(), TRUE,
                         "-hmm", usFolderPath,
                         "-lm", uslmbinfile,
                         "-dict", uscmudictfile,
                         NULL);
    if (config == NULL)
    {
        NSLog(@"Error to create config object");
        return;
    }
    
    ps = ps_init(config);
    
    if (ps == NULL)
    {
        NSLog(@"Failed to create recognizer");
        return;
    }
    
    fh = fopen([musicFile cStringUsingEncoding:NSUTF8StringEncoding], "rb");
    
    if (fh == NULL)
    {
        NSLog(@"Failed to open file");
        return;
    }
    
    rv = ps_start_utt(ps);
    
    while (!feof(fh)) {
        size_t nsamp;
        nsamp = fread(buf, 2, 512, fh);
        rv = ps_process_raw(ps, buf, nsamp, FALSE, FALSE);
    }
    
    rv = ps_end_utt(ps);
    hyp = ps_get_hyp(ps, &score);
    NSLog(@"Recognized: %s", hyp);
    
    fclose(fh);
    ps_free(ps);
    cmd_ln_free_r(config);
}

//MARK:- Helper methods
//vector<cv::Rect> detectLetters123(cv::Mat img)
//{
//    std::vector<cv::Rect> boundRect;
//    cv::Mat img_gray, img_sobel, img_threshold, element;
//    cvtColor(img, img_gray, CV_BGR2GRAY);
//    cv::Sobel(img_gray, img_sobel, CV_8U, 1, 0, 3, 1, 0, cv::BORDER_DEFAULT);
//    cv::threshold(img_sobel, img_threshold, 0, 255, CV_THRESH_OTSU+CV_THRESH_BINARY);
//    element = getStructuringElement(cv::MORPH_RECT, cv::Size(17, 3) );
//    cv::morphologyEx(img_threshold, img_threshold, CV_MOP_CLOSE, element); //Does the trick
//    std::vector< std::vector< cv::Point> > contours;
//    cv::findContours(img_threshold, contours, 0, 1);
//    std::vector<std::vector<cv::Point> > contours_poly( contours.size() );
//    for( int i = 0; i < contours.size(); i++ )
//        if (contours[i].size()>100)
//        {
//            cv::approxPolyDP( cv::Mat(contours[i]), contours_poly[i], 3, true );
//            cv::Rect appRect( boundingRect( cv::Mat(contours_poly[i]) ));
//            if (appRect.width>appRect.height)
//                boundRect.push_back(appRect);
//        }
//    return boundRect;
//}

@end
