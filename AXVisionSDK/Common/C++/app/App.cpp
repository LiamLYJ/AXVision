#include "CommonCamera.hpp"

using namespace common;
using namespace std;

typedef Eigen::Matrix<double, 6, 1> Vector6d;

void playCamera() {
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

    cout << "world2camera:\n" << res0 << endl;
    cout << "camera2world:\n" << res1 << endl;
    cout << "camera2pixel:\n" << res2 << endl;
    cout << "pixel2camera:\n" << res3 << endl;
    cout << "pixel2world:\n" << res4 << endl;
    cout << "world2pixel:\n" << res5 << endl;
}

int main () {
    
    for(int i = 1; i < 10000; i++) {
        playCamera();
    }

    return 0;
}
