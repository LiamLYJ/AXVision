//
//  ORM_SLAM.m
//  AXVisionSDK
//
//  Created by lyj on 2020/12/03.
//  Copyright © 2020 lyj. All rights reserved.
//

#include <iostream>
#include <boost/thread.hpp>
#include "LocalMapping.hpp"
#include "LoopClosing.hpp"
#include "KeyFrameDatabase.hpp"
#include "ORBVocabulary.hpp"
#include "Converter.hpp"
#import <opencv2/imgcodecs/ios.h>

#import "ORB_SLAM.h"

#import <Foundation/Foundation.h>
using namespace cv;

@implementation ORB_SLAMer

ORB_SLAM::Map* _World;
ORB_SLAM::Tracking* _Tracker;
ORB_SLAM::ORBVocabulary* _Vocabulary;
ORB_SLAM::KeyFrameDatabase* _Database;
ORB_SLAM::LocalMapping* _LocalMapper;
ORB_SLAM::LoopClosing* _LoopCloser;

bool loadVocab = true;

- (void) initORB_SLAMWithVoc:(NSString*) vocName {
    
    //ORB_SLAM::ORBVocabulary Vocabulary;
    const char *ORBvoc = [[[NSBundle mainBundle]pathForResource:vocName ofType:@"txt"] cStringUsingEncoding:[NSString defaultCStringEncoding]];
    _Vocabulary = new ORB_SLAM::ORBVocabulary();
    if (loadVocab) {
        bool bVocLoad = _Vocabulary->loadFromTextFile(ORBvoc);

        if(!bVocLoad)
        {
            cerr << "Wrong path to vocabulary. Path must be absolut or relative to ORB_SLAM package directory." << endl;
        }
    }

    _Database = new ORB_SLAM::KeyFrameDatabase(*_Vocabulary);

    //Initialize the Tracking Thread and launch

    _World = new ORB_SLAM::Map();

    const char *settings = [[[NSBundle mainBundle]pathForResource:@"Settings" ofType:@"yaml"] cStringUsingEncoding:[NSString defaultCStringEncoding]];
    _Tracker = new ORB_SLAM::Tracking(_Vocabulary, _World, settings);
    boost::thread trackingThread(&ORB_SLAM::Tracking::Run, _Tracker);

    _Tracker->SetKeyFrameDatabase(_Database);

    //Initialize the Local Mapping Thread and launch
    _LocalMapper = new ORB_SLAM::LocalMapping(_World);
    boost::thread localMappingThread(&ORB_SLAM::LocalMapping::Run, _LocalMapper);

    //Initialize the Loop Closing Thread and launch
    _LoopCloser = new ORB_SLAM::LoopClosing(_World, _Database, _Vocabulary);
    boost::thread loopClosingThread(&ORB_SLAM::LoopClosing::Run, _LoopCloser);

    //Set pointers between threads
    _Tracker->SetLocalMapper(_LocalMapper);
    _Tracker->SetLoopClosing(_LoopCloser);

    _LocalMapper->SetTracker(_Tracker);
    _LocalMapper->SetLoopCloser(_LoopCloser);

    _LoopCloser->SetTracker(_Tracker);
    _LoopCloser->SetLocalMapper(_LocalMapper);
}

- (void) initORB_SLAM {
    [self initORB_SLAMWithVoc:@"ORBvoc"];
}

- (void) trackFrame:(UIImage*) colorImage {
    Mat grayMat, dummyDepthMat;

    UIImageToMat(colorImage, grayMat);
    cv::cvtColor(grayMat, grayMat, COLOR_BGR2GRAY);
    dummyDepthMat = grayMat;

    _Tracker->GrabImage(grayMat, dummyDepthMat);
}

- (NSArray* _Nonnull) getCurrentPose_R {
    Mat pose_R;
    pose_R = _Tracker->GetPose_R();
//    std::cout << pose_R << std::endl;
    Mat flat = pose_R.reshape(1,1);
//    std::cout << flat << std::endl;
    NSMutableArray *res = [NSMutableArray array];
    std::vector<double> vec = flat.clone();
    for (int i = 0; i < 9; i ++) {
        [res addObject:[NSNumber numberWithDouble: vec[i]]];
    }
    return res;
}

- (NSArray* _Nonnull) getCurrentPose_t {
    Mat pose_t;
    pose_t = _Tracker->GetPose_T();
//    std::cout << pose_t << std::endl;
    Mat flat = pose_t.reshape(1,1);
//    std::cout << flat << std::endl;
    NSMutableArray *res = [NSMutableArray array];
    std::vector<double> vec = flat.clone();
    for (int i = 0; i < 3; i ++) {
        [res addObject:[NSNumber numberWithDouble: vec[i]]];
    }
    return res;
}

- (int) getTrackingState {
    return _Tracker->mState;
}

- (int) getnKF {
    return _World->KeyFramesInMap();
}

- (int) getnMP {
    return _World->MapPointsInMap();
}

- (void) requestSLAMReset {
    _Tracker->Reset();
}

@end
