#!/bin/bash

set -ex

# =======
# Prepare

mkdir -p workspace

# ===
# Run

run() {
    docker run -it \
    -u $(id -u):$(id -g) \
    -v `pwd`/workspace:/workspace \
    -v `pwd`/scripts:/scripts:ro \
    -v `pwd`/../opencv:/opencv:ro \
    -v `pwd`/../opencv_extra:/opencv_extra:ro \
    -e CCACHE_DIR=/workspace/.ccache \
    -e PATH=/scripts:${PATH} \
    ${tag} \
    $@
}

for platform in 22 23 fedora manual ; do

tag=opencv-gst-check-${platform}
docker build --build-arg CPUNUM=12 -t ${tag} -f Dockerfile-${platform} .
run build.sh | tee workspace/log-${platform}.txt 2>&1

done
