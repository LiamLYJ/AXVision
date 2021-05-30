find_package(Threads REQUIRED)
include(ExternalProject)

ExternalProject_Add(
    google_gtest
    URL https://github.com/google/googletest/archive/v1.10.x.zip
    PREFIX ${3rdpartyDir}/gtest
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=${3rdpartyDir}/gtest/build -DBUILD_SHARED_LIBS=OFF
)

set(GTest_INCLUDE_DIRS ${3rdpartyDir}/gtest/build/include)
set(GTest_LIBS ${3rdpartyDir}/gtest/build/lib)