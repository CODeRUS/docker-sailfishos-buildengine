#!/bin/bash

set -ex

bash build.sh buildengine.ks i486 $1
bash build.sh tooling.ks i486 $1
bash build.sh target.ks i486 $1
bash build.sh target.ks armv7hl $1