//
//  CommonUtils.hpp
//  SiteMonitor
//
//  Created by 劉永劼 on 2019/06/27.
//

#ifndef CommonUtils_hpp
#define CommonUtils_hpp

#include <math.h>

#include "CommonInclude.hpp"
#include <opencv2/imgproc.hpp>
#include <opencv2/calib3d.hpp>

namespace common {

// return 3x3, input is 1x3 matrix as roll pitch yaw order
/* http://planning.cs.uiuc.edu/node102.html.*/
Mat computeUnRotMatrix(const vector<double> &imu);

void resizeImage(const float xscale, const float yscale, Mat *image);
void rotateImage(const vector<double> &imu, Mat *image);

Mat undistortImage(const Mat &image, const vector<double> &mtx, const vector<double> &ceoff, const int caliHeight, const int caliWidth);

} // namespace common
#endif /* stitching_hpp */
