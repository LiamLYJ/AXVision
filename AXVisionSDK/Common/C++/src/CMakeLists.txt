add_library(common STATIC 
    CommonCamera.cpp
)
add_dependencies(common THIRD_CORE)
target_link_libraries(common)
