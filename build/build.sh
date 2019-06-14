#!/bin/bash

mic \
  create fs \
  -v \
  -d \
  --tokenmap=ARCH:"$2",RELEASE:"$3" \
  --arch="$2" \
  --outdir="/share/artifacts" \
  --pack-to="@NAME@-$2.tar" \
  "$1"