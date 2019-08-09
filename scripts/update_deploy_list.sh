#!/bin/sh
set -e

# Assume we're in a CircleCI context but could easily be parametrized

DEPLOY_DATE=`date +%d%b%Y`

sed -i.bak '3i\
| '"$CIRCLE_BUILD_NUM"' | '"$DEPLOY_DATE"' | \
' $1