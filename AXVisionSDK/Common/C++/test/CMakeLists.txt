
SET(TEST_SOURCES CommonCameraTest)

link_directories(
    ${GTest_LIBS}
)

FOREACH (test_src ${TEST_SOURCES})
    ADD_EXECUTABLE(${test_src} ${test_src}.cpp)
    TARGET_LINK_LIBRARIES(${test_src} GTest common)
    ADD_TEST(${test_src} ${EXECUTABLE_OUTPUT_PATH}/${test_src})
ENDFOREACH (test_src)
