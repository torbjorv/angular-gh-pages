#!/bin/sh
set -e

# Inputs
APP_VERSION=$1  #'prod' or ID
APP_FOLDER=$2   # Copy the app from here
URL_BASE=$3     # Complete base URL to gh-pages location (no trailing slash)
URL_CICD=$4     # URL for CI/CD
URL_SOURCE=$5   # URL for source

deploy_to_folder()
{
    local SRC=$1
    local DEST=$2
    local BASE_HREF=$3

    echo Deploying to $BASE_HREF
    mkdir -p $DEST
    cd $DEST  > /dev/null 2>&1
    find . -name "*" -not \( -path "./.git*" -o -path "./versions*" -o -name 404.html \) -delete
    cd -  > /dev/null 2>&1

    # Copy app
    cp -a $SRC/* $DEST
    sed -i.bak 's|.*base href.*|<base href='"$BASE_HREF"'>|' $DEST/index.html
}

main() 
{
    if [ "$APP_VERSION" == "prod" ]; then
        deploy_to_folder $APP_FOLDER . $URL_BASE/
    else
        BASE_HREF=$URL_BASE/versions/$APP_VERSION/
        deploy_to_folder $APP_FOLDER ./versions/$APP_VERSION $BASE_HREF
        deploy_to_folder $APP_FOLDER ./versions/latest $URL_BASE/versions/latest/

        # Assume we're in a CircleCI context but could easily be parametrized

        DEPLOY_DATE=`date +%d%b%Y`

        sed -i.bak '3i\
        | '"$APP_VERSION"' | '"$DEPLOY_DATE"' | [link]('"$BASE_HREF"') | [link]('"$URL_SOURCE"') | [link]('"$URL_CICD"') | | \
        ' ./versions/versions.md
    fi

    # echo Adding files to git...
    # git add -A > /dev/null 2>&1

    # echo Committing...
    # # need 'ci skip' to ignore this branch in CircleCI
    # git commit --allow-empty -m "Deploy to branch '$BRANCH' [ci skip]"  > /dev/null 2>&1
    # git push --force --quiet origin $BRANCH > /dev/null 2>&1
}

main

