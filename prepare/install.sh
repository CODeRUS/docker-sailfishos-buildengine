#!/bin/sh

set -ex

echo "## installing tooling version $1"
sdk-assistant -y create SailfishOS-$1 /share/artifacts/tooling-i486.tar

echo "## installing i486 target version $1"
sdk-assistant -y create SailfishOS-$1-i486 /share/artifacts/target-i486.tar

echo "## installing armv7hl target version $1"
sdk-assistant -y create SailfishOS-$1-armv7hl /share/artifacts/target-armv7hl.tar
