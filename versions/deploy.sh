#!/bin/sh
set -e

# Inputs
APP_VERSION=$1 #'prod' or and ID
APP_FOLDER=$2
URL_BASE=$3

# Derived variables
if [ "$APP_VERSION" == "prod" ]; then
    TARGET_FOLDER=.
    BASE_HREF=$URL_BASE/
else
    TARGET_FOLDER=./versions/$APP_VERSION
    BASE_HREF=$URL_BASE/versions/$APP_VERSION/
fi

# Setup and clean target folder. In case we update the root/prod/main version, make
# sure we keep the 404.html and 'versions' folder
echo Setup target folder...
mkdir -p $TARGET_FOLDER
cd $TARGET_FOLDER  > /dev/null 2>&1
find . -name "*" -not \( -path "./.git*" -o -path "./versions*" -o -name 404.html \) -delete
cd -  > /dev/null 2>&1

# Copy angular app
echo Copying...
cp -a $APP_FOLDER/* $TARGET_FOLDER
sed -i.bak 's|.*base href.*|<base href='"$BASE_HREF"'>|' $TARGET_FOLDER/index.html

echo Adding files to git...
git add -A > /dev/null 2>&1

echo Committing...
# need 'ci skip' to ignore this branch in CircleCI
git commit --allow-empty -m "Deploy to branch '$BRANCH' [ci skip]"  > /dev/null 2>&1
git push --force --quiet origin $BRANCH > /dev/null 2>&1