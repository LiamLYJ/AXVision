//
//  CommonUtils.m
//  AXVisionSDK
//
//  Created by lyj on 2019/10/03.
//  Copyright © 2019 lyj. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import "CommonUtils.h"
#import "CommonUtils.hpp"
#import "InternalCommonUtils.h"

@implementation CommonUtils
using std::vector;
using cv::Mat;

+ (UIImage * _Nullable) resizeImageWithImage:(UIImage * _Nonnull) image xscale:(float) xscale yscale:(float) yscale {
    Mat imageMat;
    UIImageToMat(image, imageMat);
    common::resizeImage(xscale, yscale, &imageMat);
    UIImage* result = MatToUIImage(imageMat);
    return result;
}

+ (UIImage * _Nullable) rotateImageWithImage:(UIImage * _Nonnull) image imu: (NSArray * _Nonnull) imu {
    Mat imageMat;
    UIImageToMat(image, imageMat);
    vector<double> imuvec = [InternalCommonUtils convertVector_d_ToNSArray:imu];
    common::rotateImage(imuvec, &imageMat);
    UIImage* result = MatToUIImage(imageMat);
    return result;
}

+ (UIImage * _Nullable) undistortWithUIImage:(UIImage * _Nonnull) image intrinsicMatrix: (NSArray * _Nonnull) intrinsicMatrix distortionCoeff: (NSArray * _Nonnull) distortionCoeff calibrationHeight: (int) calibrationHeight calibrationWidth: (int) calibrationWidth {
    Mat imageMat;
    UIImageToMat(image, imageMat);
    vector<double> mtxVector = [InternalCommonUtils convertVector_d_ToNSArray:intrinsicMatrix];
    vector<double> coeffVector = [InternalCommonUtils convertVector_d_ToNSArray:distortionCoeff];
    Mat undistortedImageMat = common::undistortImage(imageMat, mtxVector, coeffVector, calibrationHeight, calibrationWidth);
    return MatToUIImage(undistortedImageMat);
}

+ (UIImage * _Nullable) readImageWithPath:(NSString * _Nonnull) path {
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if ([fileManager fileExistsAtPath: path]) {
        std::string filePath = std::string([path UTF8String]);
        Mat imageMat = cv::imread(filePath);
        return MatToUIImage(imageMat);
    } else {
        return nil;
    }
}

+ (bool) compareImages:(UIImage * _Nonnull) image1 image2:(UIImage * _Nonnull) image2 {
    Mat imageMat1;
    Mat imageMat2;
    UIImageToMat(image1, imageMat1);
    UIImageToMat(image2, imageMat2);
    cv::cvtColor(imageMat1, imageMat1, cv::COLOR_BGR2GRAY);
    cv::cvtColor(imageMat2, imageMat2, cv::COLOR_BGR2GRAY);
    uint sum = 0;
    for(int i = 0; i < imageMat1.rows; i++)
    {
        const uint8_t* img1 = imageMat1.ptr<uint8_t>(i);
        const uint8_t* img2 = imageMat2.ptr<uint8_t>(i);
        for(int j = 0; j < imageMat1.cols; j++) {
            int diff = std::abs(img1[j] - img2[j]);
            if (diff > 3) {
                sum += diff;
            }
        }
    }
    if (sum < 10) {
        return true;
    } else {
        return false;
    }
}
@end
