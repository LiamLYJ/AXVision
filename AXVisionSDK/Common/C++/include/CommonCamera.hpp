#ifndef CAMERA_HPP
#define CAMERA_HPP

#include "CommonInclude.hpp"
#include <sophus/so3.hpp>
#include <sophus/se3.hpp>

namespace common
{
using Sophus::SE3;
using Sophus::SO3;

// Pinhole RGBD camera model
class Camera
{
public:
    typedef std::shared_ptr<Camera> Ptr;
    double fx_, fy_, cx_, cy_, depth_scale_;

    Camera();
    Camera(
        float fx, 
        float fy, 
        float cx, 
        float cy, 
        float depth_scale = 0
    ) : fx_(fx), fy_(fy), cx_(cx), cy_(cy), depth_scale_(depth_scale) {}

    Camera(
        double fx, 
        double fy, 
        double cx, 
        double cy, 
        double depth_scale = 0
    ) : fx_(fx), fy_(fy), cx_(cx), cy_(cy), depth_scale_(depth_scale) {}

    // coordinate transform: world, camera, pixel
    Vector3d world2camera(const Vector3d &p_w, const SE3<double> &T_c_w);
    Vector3d camera2world(const Vector3d &p_c, const SE3<double> &T_c_w);
    Vector2d camera2pixel(const Vector3d &p_c);
    Vector3d pixel2camera(const Vector2d &p_p, double depth = 1);
    Vector3d pixel2world(const Vector2d &p_p, const SE3<double> &T_c_w, double depth = 1);
    Vector2d world2pixel(const Vector3d &p_w, const SE3<double> &T_c_w);

    inline double getFx() const {
        return fx_;
    }

    inline double getFy() const {
        return fy_;
    }

    inline double getCx() const {
        return cx_;
    }

    inline double getCy() const {
        return cy_;
    }

    inline double getDepthScale() const {
        return depth_scale_;
    }
    inline double getFocalLength() const {
        return (fx_ + fy_) / 2.0;
    }

    inline cv::Point2d getPrincipalPoint() const {
        return cv::Point2d(cx_,cy_);
    }

private:
    DISALLOW_COPY_AND_ASSIGN(Camera);
};

} // namespace common 
#endif // CAMERA_HPP
