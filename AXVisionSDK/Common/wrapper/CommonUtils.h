//
//  CommonUtils.h
//  AXVisionSDK
//
//  Created by lyj on 2019/10/03.
//  Copyright © 2019 lyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CommonUtils : NSObject
+ (UIImage * _Nullable) readImageWithPath:(NSString * _Nonnull) path;
+ (UIImage * _Nullable) resizeImageWithImage:(UIImage * _Nonnull) image xscale:(float) xscale yscale:(float) yscale;
+ (UIImage * _Nullable) undistortWithUIImage:(UIImage * _Nonnull) image intrinsicMatrix: (NSArray * _Nonnull) intrinsicMatrix distortionCoeff: (NSArray * _Nonnull) distortionCoeff calibrationHeight: (int) calibrationHeight calibrationWidth: (int) calibrationWidth;
+ (UIImage * _Nullable) rotateImageWithImage:(UIImage * _Nonnull) image imu:(NSArray * _Nonnull) imu;
+ (bool) compareImages:(UIImage * _Nonnull) image1 image2:(UIImage * _Nonnull) image2;
@end
