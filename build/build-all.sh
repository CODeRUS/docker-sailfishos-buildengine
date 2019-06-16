#!/bin/bash

set -ex

bash /share/build/build.sh /share/build/buildengine.ks i486 $1
bash /share/build/build.sh /share/build/tooling.ks i486 $1
bash /share/build/build.sh /share/build/target.ks i486 $1
bash /share/build/build.sh /share/build/target.ks armv7hl $1