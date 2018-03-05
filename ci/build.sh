#!/bin/bash
set -ex

GITHUB_RELEASE_VERSION="0.7.2"
USER_NAME="prijindal"
REPO_NAME="habiticapp"
TAG_NAME="auto-build"


export PATH="$PWD/flutter/bin:$PWD/flutter/bin/cache/dart-sdk/bin:$PATH"

echo "Building Application"
if [ "$TRAVIS_OS_NAME" = "linux" ]; then
  export ANDROID_HOME=`pwd`/android-sdk
  flutter build apk --release
  echo "Android Application built"

  echo "Deploying Android application to Github"

  wget "https://github.com/aktau/github-release/releases/download/v$GITHUB_RELEASE_VERSION/linux-amd64-github-release.tar.bz2"
  mkdir github-release
  tar xvjf linux-amd64-github-release.tar.bz2 -C github-release

  ./github-release/bin/linux/amd64/github-release upload -u $USER_NAME -r $REPO_NAME --tag $TAG_NAME --name "app-release.apk" --file build/app/outputs/apk/release/app-release.apk -R
  ./github-release/bin/linux/amd64/github-release edit -u $USER_NAME -r $REPO_NAME --tag $TAG_NAME --name "Pre Release $(date)"
  echo "Android Deploy Successfull"

elif [ "$TRAVIS_OS_NAME" = "osx" ]; then
  echo "Building Application for iOS..."
  flutter build ios --release --no-codesign
  echo "iOS Application built"

  # echo "Deploying Ios application to Github"
  # wget "https://github.com/aktau/github-release/releases/download/v$GITHUB_RELEASE_VERSION/darwin-amd64-github-release.tar.bz2"
  # mkdir github-release
  # tar xvjf darwin-amd64-github-release.tar.bz2 -C github-release
  # ./github-release/bin/darwin/amd64/github-release upload -u $USER_NAME -r $REPO_NAME --tag $TAG_NAME --name "Runner.app" --file build/ios/iphoneos/Runner.app -R
  # echo "Ios Deploy Successfull"

fi