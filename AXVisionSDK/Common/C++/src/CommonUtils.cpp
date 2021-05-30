//
//  CommonUtils.cpp
//  SiteMonitor
//
//  Created by 劉永劼 on 2019/06/27.
//

#include "CommonUtils.hpp"

namespace common {

Mat computeUnRotMatrix(const vector<double> &imu) {
    double a = imu[0] * M_PI / 180.0;
    double b = imu[1] * M_PI / 180.0;
    double g = imu[2] * M_PI / 180.0;

    Mat Rz = (cv::Mat_<double>(3,3) << cos(a), -sin(a), 0,\
              sin(a), cos(a), 0,\
              0, 0, 1);
    Mat Ry = (cv::Mat_<double>(3,3) << cos(b), 0,  sin(b),\
              0, 1, 0,\
              -sin(b), 0, cos(b));
    Mat Rx = (cv::Mat_<double>(3,3) << 1, 0, 0,\
              0, cos(g), -sin(g),\
              0, sin(g), cos(g));
    Mat Ryx = Rx * Ry;
    Mat R = Rz * Ryx;
    R.at<double>(0,2) = 0;
    R.at<double>(1,2) = 0;
    R.at<double>(2,2) = 1;
    Mat Rtrans = Rz.t();
    Mat InvR = Rtrans.inv();

    // return the inverse of R, undo by imu
    return InvR;
}

void rotateImage(const vector<double> &imu, Mat *image) {
    // get rotation matrix for rotating the image around its center in pixel coordinates
    cv::Point2f center((image->cols-1)/2.0, (image->rows-1)/2.0);
    double angle = -imu[0];
    Mat rot = cv::getRotationMatrix2D(center, angle, 1.0);
    // determine bounding rectangle, center not relevant
    cv::Rect2f bbox = cv::RotatedRect(cv::Point2f(), image->size(), angle).boundingRect2f();
    // adjust transformation matrix
    rot.at<double>(0,2) += bbox.width/2.0 - image->cols/2.0;
    rot.at<double>(1,2) += bbox.height/2.0 - image->rows/2.0;

    warpAffine(*image, *image, rot, bbox.size());
}

void resizeImage(const float xscale, const float yscale, Mat *image) {
    resize(*image, *image, cv::Size(), xscale, yscale, cv::INTER_CUBIC);
}

Mat undistortImage(const Mat &image, const vector<double> &mtx, const vector<double> &coeff, const int caliHeight, const int caliWidth) {
    Mat cameraMatrix;
    cameraMatrix = (cv::Mat_<double>(3,3) << mtx[0], mtx[1], mtx[2], \
                    mtx[3], mtx[4], mtx[5], \
                    mtx[6], mtx[7], mtx[8]);
    cv::Size caliSize(caliWidth, caliHeight);
    Mat newCameraMatrix = cv::getOptimalNewCameraMatrix(cameraMatrix, coeff, caliSize, 1.0, image.size());
    Mat undistortedImage;
    cv::undistort(image, undistortedImage, newCameraMatrix, coeff);
    return undistortedImage;
}

} // namespace common
