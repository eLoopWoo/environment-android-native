#!/usr/bin/env bash

function welcome(){
        if [ -z $ANDROID_RESEARCH_ENABLE ] ; then
                echo "error: \$ANDROID_RESEARCH_ENABLE is not set"
                exit 1
        fi

        if [ -z $1 ] || [ -z $2 ] ; then
                echo "usage: ./install_project project_name cli/gui"
                exit 1
        fi

        if [ "$2" != "cli" ] && [ $2 != "gui" ] ; then
                echo "usage: ./install_project project_name cli/gui"
                exit 1
        fi

}

function install_project(){
	echo "[*] Installing Project"
	if [ $2 == "gui" ] ; then
		echo "[*] Installing $ANDROID_RESEARCH_ENV/projects/$1/build/$1.apk"
		$ANDROID_RESEARCH_BUILD_TOOLS/platform-tools/adb install -r "$ANDROID_RESEARCH_ENV/projects/$1/build/$1.apk"
	else 
		echo "[*] Copying $ANDROID_RESEARCH_ENV/projects/$1/cpp/obj/local/armeabi-v7a/native-lib to /data/local/tmp/$1"
		$ANDROID_RESEARCH_BUILD_TOOLS/platform-tools/adb push $ANDROID_RESEARCH_ENV/projects/$1/cpp/obj/local/armeabi-v7a/native-lib /data/local/tmp/$1
	fi

}

function main(){
	welcome $1 $2
	install_project $1 $2
}

main $1 $2
echo "[*] Done!"
