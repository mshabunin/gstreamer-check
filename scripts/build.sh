#!/bin/bash

set -ex

build() {
D=$1 ; shift 1
mkdir -p $D
pushd $D && rm -rf *
cmake -GNinja \
        -DCMAKE_BUILD_TYPE=Release \
        -DWITH_FFMPEG=OFF \
        -DWITH_V4L=OFF \
        -DWITH_GSTREAMER=ON \
        ${@} \
    /opencv
ninja
}


test_() {
D=$1 ; shift 1
pushd $D
OPENCV_TEST_DATA_PATH=/opencv_extra/testdata \
    ./bin/opencv_test_videoio --gtest_filter=*:-*audio*
popd
}

build /workspace/build-opencv
test_ /workspace/build-opencv
