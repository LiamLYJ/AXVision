//
//  InternalCommonUtils.h
//  AXVisionSDK
//
//  Created by lyj on 2019/12/11.
//  Copyright © 2019 lyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Eigen/Core>
#import <Eigen/Dense>
#import <vector>

@interface InternalCommonUtils : NSObject
+ (NSArray* _Nonnull) convertM3dToNSArray:(Eigen::Matrix3d) inputMatrix;
+ (NSArray* _Nonnull) convertV3dToNSArray:(Eigen::Vector3d) inputVector;
+ (NSArray* _Nonnull) convertV2dToNSArray:(Eigen::Vector2d) inputVector;
+ (Eigen::Vector2d) convertNSArrayToV2d:(NSArray *) array;
+ (Eigen::Vector3d) convertNSArrayToV3d:(NSArray *) array; // TODO: Need some spefic case to cover its test
+ (Eigen::Matrix3d) convertNSArrayToM3d:(NSArray *) array; // TODO: Need some spefic case to cover its test

+ (NSArray*) convertNSArrayToVector_d:(std::vector<double>) vector_d; // TODO: Need some spefic case to cover its test
+ (NSArray*) convertNSArrayToVector_f:(std::vector<float>) vector_f; // TODO: Need some spefic case to cover its test
+ (NSArray*) convertNSArrayToVector_i:(std::vector<int>) vector_i; // TODO: Need some spefic case to cover its test
+ (std::vector<double>) convertVector_d_ToNSArray:(NSArray *) array;
+ (std::vector<float>) convertVector_f_ToNSArray:(NSArray *) array; // TODO: Need some spefic case to cover its test
+ (std::vector<int>) convertVector_i_ToNSArray:(NSArray *) array; // TODO: Need some spefic case to cover its test
@end
