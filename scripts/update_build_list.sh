#!/bin/sh
set -e


BUILD_DATE=`date +%d%b%Y`

sed -i.bak '3i\
| '"$BUILD_DATE"' | \
' $1