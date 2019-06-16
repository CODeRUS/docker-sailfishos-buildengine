#!/bin/bash

USERDIR=$(eval echo ~$USER)
SDK=$(grep MerSDK.InstallDir -A1 $USERDIR/.config/SailfishOS-SDK/qtcreator/mersdk.xml | tail -n 1 | sed -e 's/<[^>]*>//g' | tr -d '[:space:]')
SDK=${SDK:-$USERDIR/SailfishOS}

IMAGE_NAME="buildengine-sdk"
CONTAINER_NAME="buildengine-sdk-instance"

docker run -d --rm \
    --privileged \
    -p "2222:2222" \
    -p "8080:8080" \
	--name "$CONTAINER_NAME" \
    --volume "$USERDIR:/home/mersdk/share" \
    --volume "$USERDIR:/home/src1" \
    --volume "$SDK/mersdk/ssh:/etc/ssh/authorized_keys" \
    --volume "$SDK/mersdk/targets:/host_targets" \
    --volume "$SDK/vmshare:/etc/mersdk/share" \
    --workdir "/home/mersdk/share" \
    "$IMAGE_NAME" \
    "$@"