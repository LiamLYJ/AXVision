//
//  ORB_SLAM.h
//  AXVisionSDK
//
//  Created by lyj on 2020/12/03.
//  Copyright © 2020 lyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonUtils.h"
#import <SceneKit/SceneKit.h>

@interface ORB_SLAMer : NSObject

- (void) initORB_SLAM;
- (void) initORB_SLAMWithVoc: (NSString* _Nonnull) vocName;
- (void) trackFrame:(UIImage* _Nonnull) colorImage;
- (int) getTrackingState;
- (NSArray* _Nonnull) getCurrentPose_R;
- (NSArray* _Nonnull) getCurrentPose_t;
- (int) getnKF;
- (int) getnMP;
- (void) requestSLAMReset;

@end
