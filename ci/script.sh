#!/bin/bash
set -ex

export PATH="$PWD/flutter/bin:$PWD/flutter/bin/cache/dart-sdk/bin:$PATH"

if [ "$SHARD" = "build_and_deploy" ]; then
  echo "Building Application"
  if [ "$TRAVIS_OS_NAME" = "linux" ]; then
    export ANDROID_HOME=`pwd`/android-sdk
    ./flutter/bin/flutter build apk --release
    echo "Android Application built"
  elif [ "$TRAVIS_OS_NAME" = "osx" ]; then
    echo "Building Application for iOS..."
    flutter build ios --release -no-codesign
    echo "iOS Flutter Gallery built"
  fi
else
  dartanalyzer lib
fi
