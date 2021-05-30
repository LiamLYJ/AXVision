cmake_minimum_required(VERSION 3.2)
project(Common)

if(${USEDEBUG})
  set(CMAKE_BUILD_TYPE Debug)
else()
  set(CMAKE_BUILD_TYPE Release)
endif()

message("Build type: " ${CMAKE_BUILD_TYPE})

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
if(NOT CYGWIN)
  set(CMAKE_CXX_EXTENSIONS OFF)
endif()

set(EXECUTABLE_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/build/bin)
set(LIBRARY_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/build/lib)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmakeModules")

# Eigen
find_package( Eigen3 REQUIRED)

# OpenCV 
find_package( OpenCV 4.1 REQUIRED )

# set 3rdparty path
message(STATUS "pwd src:" ${CMAKE_CURRENT_SOURCE_DIR})
message(STATUS "pwd bin:" ${CMAKE_CURRENT_BINARY_DIR})
get_filename_component(tmp_dir ${CMAKE_CURRENT_SOURCE_DIR} PATH)
get_filename_component(3rdpartyDir ${tmp_dir} PATH)
set(3rdpartyDir "${3rdpartyDir}/3rdparty")
message(STATUS "3rdparty paths:" ${3rdpartyDir})

add_custom_target(THIRD_CORE)

# GTest
find_package(GTest REQUIRED)
# Sophus
find_package(Sophus REQUIRED)

include_directories(
  ${OpenCV_INCLUDE_DIRS}
  ${EIGEN3_INCLUDE_DIRS}
  ${Sophus_INCLUDE_DIRS}
  ${GTest_INCLUDE_DIRS}
)

enable_testing()

############### source and test ######################
include_directories(${PROJECT_SOURCE_DIR}/include)
add_subdirectory(src)

add_subdirectory(app)
add_subdirectory(test)
