#!/usr/bin/env bash


function welcome(){
	base64 "misc/logo$(( ( RANDOM %  $(ls misc/ | grep logo | wc -l)  ) ))" --decode
	ANDROID_RESEARCH_SOURCE="1"
	if [ -z "$1" ]; then
		echo "usage: source configure project_path"
		ANDROID_RESEARCH_SOURCE="0"
	fi
}

function configure(){
	ANDROID_RESEARCH_ENABLE="1"
	ANDROID_RESEARCH_HOME=$(readlink -f $1)
	ANDROID_RESEARCH_ENV=$ANDROID_RESEARCH_HOME/environment
	ANDROID_RESEARCH_JDK=$ANDROID_RESEARCH_HOME/jdk1.8.0_191
	ANDROID_RESEARCH_SDK=$ANDROID_RESEARCH_HOME/sdk_tools
	ANDROID_RESEARCH_NDK=$ANDROID_RESEARCH_HOME/android-ndk-r18b
	ANDROID_RESEARCH_NDK_GDB=$ANDROID_RESEARCH_NDK/prebuilt/linux-x86_64/bin/gdb
	ANDROID_RESEARCH_BUILD_TOOLS=$ANDROID_RESEARCH_SDK/build_tools
	ANDROID_RESEARCH_PLATFORM_VERSION="android-16"
	ANDROID_RESEARCH_PLATFORM=$ANDROID_RESEARCH_BUILD_TOOLS/platforms/$ANDROID_RESEARCH_PLATFORM_VERSION
}

function main(){	
	welcome $1
	if [ $ANDROID_RESEARCH_SOURCE = "1" ]; then
		echo "** Android Arm Research **"
		configure $1
		echo "[*] Done!"
	fi
}

main $1
