//
//  InternalCommonUtils.m
//  AXVisionSDK
//
//  Created by lyj on 2019/12/11.
//  Copyright © 2019 lyj. All rights reserved.
//

#import "InternalCommonUtils.h"
#import <Foundation/Foundation.h>

@implementation InternalCommonUtils

+ (NSArray* _Nonnull)convertM3dToNSArray:(Eigen::Matrix3d) inputMatrix {
    NSMutableArray* outputArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            [outputArray addObject:[NSNumber numberWithDouble:inputMatrix(i,j)]];
        }
    }
   return outputArray;
}

+ (NSArray* _Nonnull)convertV3dToNSArray:(Eigen::Vector3d) inputVector {
    NSMutableArray* outputArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 3; i++) {
        [outputArray addObject:[NSNumber numberWithDouble:inputVector(i)]];
    }
    return outputArray;
}

+ (NSArray* _Nonnull)convertV2dToNSArray:(Eigen::Vector2d) inputVector {
    NSMutableArray* outputArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 2; i++) {
        [outputArray addObject:[NSNumber numberWithDouble:inputVector(i)]];
    }
    return outputArray;
}

+ (Eigen::Vector2d) convertNSArrayToV2d: (NSArray *) array {
    Eigen::Vector2d res;
    res(0) = [array[0] doubleValue];
    res(1) = [array[1] doubleValue];
    return res;
}

+ (Eigen::Vector3d) convertNSArrayToV3d: (NSArray *) array {
    Eigen::Vector3d res;
    res(0) = [array[0] doubleValue];
    res(1) = [array[1] doubleValue];
    res(2) = [array[2] doubleValue];
    return res;
}

+ (Eigen::Matrix3d) convertNSArrayToM3d: (NSArray *) array {
    Eigen::Matrix3d res;
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j ++) {
            res(i,j) = [array[i*3+j] doubleValue];
        }
    }
    return res;
}

+ (NSArray*) convertNSArrayToVector_d:(std::vector<double>) vector_d {
    NSMutableArray* outputArray = [[NSMutableArray alloc] init];
    for (double const &value: vector_d) {
        [outputArray addObject:[NSNumber numberWithDouble:value]];
    }
    return outputArray;
}

+ (NSArray*) convertNSArrayToVector_f:(std::vector<float>) vector_f {
    NSMutableArray* outputArray = [[NSMutableArray alloc] init];
    for (float const &value: vector_f) {
        [outputArray addObject:[NSNumber numberWithFloat:value]];
    }
    return outputArray;
}

+ (NSArray*) convertNSArrayToVector_i:(std::vector<int>) vector_i {
    NSMutableArray* outputArray = [[NSMutableArray alloc] init];
    for (int const &value: vector_i) {
        [outputArray addObject:[NSNumber numberWithInt:value]];
    }
    return outputArray;
}

+ (std::vector<double>) convertVector_d_ToNSArray:(NSArray *) array {
    std::vector<double> res;
    for (int i = 0; i < [array count]; i++) {
        res.push_back([array[i] doubleValue]);
    }
    return res;
}

+ (std::vector<float>) convertVector_f_ToNSArray:(NSArray *) array {
    std::vector<float> res;
    for (int i = 0; i < [array count]; i++) {
        res.push_back([array[i] floatValue]);
    }
    return res;
}

+ (std::vector<int>) convertVector_i_ToNSArray:(NSArray *) array {
    std::vector<int> res;
    for (int i = 0; i < [array count]; i++) {
        res.push_back([array[i] intValue]);
    }
    return res;
}
@end
