#!/bin/bash
set -ex

HUB_VERSION="2.2.9"

export PATH="$PWD/flutter/bin:$PWD/flutter/bin/cache/dart-sdk/bin:$PATH"

if [ "$SHARD" = "build_and_deploy" ]; then
  echo "Building Application"
  if [ "$TRAVIS_OS_NAME" = "linux" ]; then
    export ANDROID_HOME=`pwd`/android-sdk
    flutter build apk --release
    echo "Android Application built"
    echo "Deploying to Github"
    wget "https://github.com/github/hub/releases/download/v$HUB_VERSION/hub-linux-amd64-$HUB_VERSION.tgz"
    tar -xf "hub-linux-amd64-$HUB_VERSION.tgz"
    ./hub-linux-amd64-$HUB_VERSION/bin/hub release create -p -a build/app/outputs/apk/release/app-release.apk -m "Pre Release $(date)" "android"
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
