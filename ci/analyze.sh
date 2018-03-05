#!/bin/bash
set -ex

export PATH="$PWD/flutter/bin:$PWD/flutter/bin/cache/dart-sdk/bin:$PATH"

dart flutter/bin/cache/dart-sdk/bin/snapshots/dartanalyzer.dart.snapshot lib/
