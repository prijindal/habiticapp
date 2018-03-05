#!/bin/bash
set -e

export ANDROID_HOME=`pwd`/android-sdk
./flutter/bin/flutter build apk --release
