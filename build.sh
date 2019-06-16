#!/bin/bash

set -ex

BASEIMAGE="coderus/sailfishos-baseimage"
RELEASE=${1:-3.0.3.9}

docker run --rm -it \
    --privileged \
    -v "$PWD:/share" \
    -w "/share" \
    coderus/sailfishos-baseimage \
    "/bin/bash" "/share/build/build-all.sh" "$RELEASE"

IMAGE_BASE_NAME="buildengine-base"

docker import \
    artifacts/buildengine-i486.tar \
    "$IMAGE_BASE_NAME"

USERDIR=$(eval echo ~$USER)
SDK=$(grep MerSDK.InstallDir -A1 $USERDIR/.config/SailfishOS-SDK/qtcreator/mersdk.xml | tail -n 1 | sed -e 's/<[^>]*>//g' | tr -d '[:space:]')
SDK=${SDK:-$USERDIR/SailfishOS}

IMAGE_SDK_NAME="buildengine-sdk"
CONTAINER_NAME="buildengine-prepare"

LOCAL_UID=$(id -u)
LOCAL_GID=$(id -g)

echo "# RELEASE: $RELEASE"
echo "# LOCAL_UID: $LOCAL_UID, LOCAL_GID: $LOCAL_GID"

docker run -it \
    --name "$CONTAINER_NAME" \
    --volume "$USERDIR:/home/mersdk/share" \
    --volume "$USERDIR:/home/src1" \
    --volume "$SDK/mersdk/ssh:/etc/ssh/authorized_keys" \
    --volume "$SDK/mersdk/targets:/host_targets" \
    --volume "$SDK/vmshare:/etc/mersdk/share" \
    --volume "$PWD:/share" \
    --workdir "/share" \
    "$IMAGE_BASE_NAME" \
    "/bin/bash" "/share/prepare/prepare.sh" "$LOCAL_UID" "$LOCAL_GID" "$RELEASE"

docker commit \
    -p \
    -c "USER mersdk" \
    -c "WORKDIR /home/mersdk" \
    -c "CMD [\"/start.sh\"]" \
    -c "EXPOSE 2222" \
    -c "EXPOSE 8080" \
    $CONTAINER_NAME $IMAGE_SDK_NAME

docker rm $CONTAINER_NAME
