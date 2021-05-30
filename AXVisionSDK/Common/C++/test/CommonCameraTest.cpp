#include "CommonCamera.hpp"
#include "gtest/gtest.h"

using namespace common;

typedef Eigen::Matrix<double, 6, 1> Vector6d;


TEST(camera, projection)
{
    Eigen::Matrix3d R = Eigen::Matrix3d::Zero();
    R(0,0) = 1; R(1,1) = 1; R(2,2) = 1;
    Vector3d t(100,0,0);
    Sophus::SE3<double> se3(R, t);
 
    Vector6d se_vector = se3.log();
    Vector3d p_w(100, 100, 100);
    Vector3d p_c(100, 100, 100);
    Vector2d p_p(100, 100);

    Camera camera(1000.0, 1000.0, 500.0, 500.0, 1.0);

    Vector3d res0 = camera.world2camera(p_w, se3);
    Vector3d res1 = camera.camera2world(p_c, se3);
    Vector2d res2 = camera.camera2pixel(p_c);
    Vector3d res3 = camera.pixel2camera(p_p);
    Vector3d res4 = camera.pixel2world(p_p, se3);
    Vector2d res5 = camera.world2pixel(p_w, se3);

    Vector3d res0_exp(200,100,100);
    Vector3d res1_exp(0,100,100);
    Vector2d res2_exp(1500, 1500);
    Vector3d res3_exp(-0.4, -0.4, 1);
    Vector3d res4_exp(-100.4, -0.4, 1);
    Vector2d res5_exp(2500, 1500);

    ASSERT_TRUE((res0 - res0_exp).norm() < 1e-6);
    ASSERT_TRUE((res1 - res1_exp).norm() < 1e-6);
    ASSERT_TRUE((res2 - res2_exp).norm() < 1e-6);
    ASSERT_TRUE((res3 - res3_exp).norm() < 1e-6);
    ASSERT_TRUE((res4 - res4_exp).norm() < 1e-6);
    ASSERT_TRUE((res5 - res5_exp).norm() < 1e-6);
}

int main(int argc, char **argv)
{

    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
