#!/bin/sh
start_time=`date +%s`
export PATH=$HOME/softwares/android/studio/jre/bin:$PATH

cd android &&
./gradlew assembleRelease &&
# ./gradlew assembleDebug

# ./gradlew --status

# ./gradlew assembleRelease

# /home/prijindal/softwares/android/studio/jre/bin/java -Dorg.gradle.appname=gradlew -classpath /home/prijindal/projects/habiticapp/android/gradle/wrapper/gradle-wrapper.jar org.gradle.wrapper.GradleWrapperMain -q -Ptarget=/home/prijindal/projects/habiticapp/lib/main.dart assembleRelease

# /home/prijindal/softwares/android/studio/jre/bin/java -Xmx256M -Dfile.encoding=UTF-8 -Duser.country=US -Duser.language=en -Duser.variant -cp /home/prijindal/.gradle/wrapper/dists/gradle-4.1-all/bzyivzo6n839fup2jbap0tjew/gradle-4.1/lib/gradle-launcher-4.1.jar org.gradle.launcher.daemon.bootstrap.GradleDaemon 4.1

cd ../

adb install -r build/app/outputs/apk/release/app-release.apk &&
# adb install -r build/app/outputs/apk/debug/app-debug.apk

adb shell am start -n com.prijindal.habitter/com.prijindal.habitter.MainActivity

echo run time is $(expr `date +%s` - $start_time) s
