#ifndef COMMONINCLUDE_HPP
#define COMMONINCLUDE_HPP

// define the commonly included file to avoid a long include list
// for Eigen
#include <Eigen/Core>
#include <Eigen/Geometry>

// for cv
#include <opencv2/core/core.hpp>

// std
#include <vector>
#include <list>
#include <memory>
#include <string>
#include <iostream>
#include <set>
#include <unordered_map>
#include <map>

#define DISALLOW_COPY_AND_ASSIGN(TypeName)  TypeName(const TypeName&); void operator=(const TypeName&)

namespace common {

using Eigen::Vector2d;
using Eigen::Vector3d;
using cv::Mat;
using std::vector;

} // namespace common

#endif
