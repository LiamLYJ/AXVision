find_package(Threads REQUIRED)
include(ExternalProject)

list(APPEND CMAKE_ARGS
    "-DBUILD_SHARED_LIBS=OFF"
    "-DCMAKE_INSTALL_PREFIX:PATH=${3rdpartyDir}/sophus/build"
)
set(SAVE_PREFIX ${3rdpartyDir}/sophus)

message(STATUS "Preparing external project \"Sophus\" with args:")
foreach(CMAKE_ARG ${CMAKE_ARGS})
    message(STATUS "-- ${CMAKE_ARG}")
endforeach()

ExternalProject_Add(
    sophus
    URL https://github.com/strasdat/Sophus/archive/v1.0.0.zip
    PREFIX ${SAVE_PREFIX}
    CMAKE_ARGS ${CMAKE_ARGS}
)

add_dependencies(THIRD_CORE sophus)

set(Sophus_INCLUDE_DIRS ${3rdpartyDir}/sophus/build/include)