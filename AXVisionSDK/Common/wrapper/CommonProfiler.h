//
//  CommonProfiler.h
//  AXVisionSDK
//
//  Created by lyj on 2019/12/03.
//  Copyright © 2019 lyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonProfiler : NSObject

@property (nonatomic, assign) int count;
@property (nonatomic, assign) float totalTimeInterval;
@property (nonatomic, assign) float lastInterval;
@property (nonatomic, strong, nullable) NSDate* time;

- (float) getAverageTime;
- (long) getLastTime;
- (void) start;
- (void) end;
- (instancetype _Nonnull) init;

@end
