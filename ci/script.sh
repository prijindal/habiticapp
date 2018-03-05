#!/bin/bash
set -ex

GITHUB_RELEASE_VERSION="0.7.2"
USER_NAME="prijindal"
REPO_NAME="habiticapp"
TAG_NAME="v0.0.1"


export PATH="$PWD/flutter/bin:$PWD/flutter/bin/cache/dart-sdk/bin:$PATH"

if [ "$SHARD" = "build_and_deploy" ]; then
  echo "Building Application"
  if [ "$TRAVIS_OS_NAME" = "linux" ]; then
    export ANDROID_HOME=`pwd`/android-sdk
    flutter build apk --release
    echo "Android Application built"
    echo "Deploying to Github"
    wget "https://github.com/aktau/github-release/releases/download/v$GITHUB_RELEASE_VERSION/linux-amd64-github-release.tar.bz2"
    mkdir github-release
    tar xvjf linux-amd64-github-release.tar.bz2 -C github-release
    # ./github-release/bin/linux/amd64/github-release delete -u $USER_NAME -r $REPO_NAME --tag "v0.0.1"
    # ./github-release/bin/linux/amd64/github-release release -u $USER_NAME -r $REPO_NAME --tag "v0.0.1" -p --name "Pre Release $(date)"
    ./github-release/bin/linux/amd64/github-release upload -u $USER_NAME -r $REPO_NAME --tag "v0.0.1" --name "app-release" --file build/app/outputs/apk/release/app-release.apk -R
    echo "Deployed Succesfully"
    # Add to github release
  elif [ "$TRAVIS_OS_NAME" = "osx" ]; then
    echo "Building Application for iOS..."
    flutter build ios --release --no-codesign
    echo "iOS Application built"
  fi
else
  flutter packages get
  dart flutter/bin/cache/dart-sdk/bin/snapshots/dartanalyzer.dart.snapshot lib/
fi
