#!/bin/sh
set -e

GH_TOKEN=$1
TARGET_FOLDER=$2
BASE_HREF=$3
BRANCH=gh-pages
REPO=torbjorv/angular-gh-pages.git

TMP_DIR=tmp-$BRANCH

echo Target: $TARGET_FOLDER
echo Branch: $BRANCH
echo Repo: $REPO

# All git output below is sent to dev/null to avoid exposing anything sensitive in build logs

echo Checking out $BRANCH
mkdir $TMP_DIR
cd $TMP_DIR

git config --global user.name "CircleCI"  > /dev/null 2>&1
git init  > /dev/null 2>&1
git remote add --fetch origin https://$GH_TOKEN@github.com/$REPO > /dev/null 2>&1

git checkout $BRANCH > /dev/null 2>&1

# Prepare for next/new version
echo Setup target folder...
mkdir -p $TARGET_FOLDER
cd $TARGET_FOLDER  > /dev/null 2>&1

# Hopefully these are
find . -type f -not -name '404.html'-delete
cd -  > /dev/null 2>&1

# Copy angular app
echo Copying...
cp -a ../dist/* $TARGET_FOLDER
sed -i.bak 's|.*base href.*|<base href='"$BASE_HREF"'>|' $TARGET_FOLDER/index.html

echo Adding files to git...
git add -A > /dev/null 2>&1

echo Committing...
# need 'ci skip' to ignore this branch in CircleCI
git commit --allow-empty -m "Deploy to branch '$BRANCH' [ci skip]"  > /dev/null 2>&1
git push --force --quiet origin $BRANCH > /dev/null 2>&1

echo Cleaning up...
cd ..
rm -rf $TMP_DIR