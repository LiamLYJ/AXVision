//
//  CommonProfiler.m
//  AXVisionSDK
//
//  Created by lyj on 2019/12/03.
//  Copyright © 2019 lyj. All rights reserved.
//

#import "CommonProfiler.h"

@implementation CommonProfiler

-(instancetype) init {
    self = [super init];
    if (self) {
        self.count = 0;
        self.totalTimeInterval = 0;
        self.lastInterval = -1;
    }
    return self;
}

-(void) start {
    self.time = [NSDate date];
}

-(void) end {
    self.count++;
    self.lastInterval = -[self.time timeIntervalSinceNow];
    self.totalTimeInterval += self.lastInterval;
}

-(long) getLastTime {
    return self.lastInterval;
}

-(float) getAverageTime {
    if (self.count == 0)
        return -1;
    else
        return static_cast<float>(self.totalTimeInterval/static_cast<float>(self.count));
}

@end
