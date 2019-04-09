#!/usr/bin/env bash

function welcome(){
        if [ -z $ANDROID_RESEARCH_ENABLE ] ; then
                echo "error: \$ANDROID_RESEARCH_ENABLE is not set"
                exit 1
        fi

        if [ -z $1 ] || [ -z $2 ]; then
                echo "usage: ./build_project project_name cli/gui"
                exit 1
        fi

        if [ "$2" != "cli" ] && [ $2 != "gui" ] ; then
                echo "usage: ./build_project project_name cli/gui"
                exit 1
        fi
}

function build_project(){
	echo "[*] Building Project"
	
	local buildtools=$ANDROID_RESEARCH_BUILD_TOOLS
	local platform=$ANDROID_RESEARCH_PLATFORM
	local java_jdk=$ANDROID_RESEARCH_JDK
	local ndk=$ANDROID_RESEARCH_NDK

	cd projects/$1
	echo "[*] Compile Native Arm"
	cd cpp
	"$ndk/ndk-build" NDK_PROJECT_PATH=. NDK_APPLICATION_MK=./Application.mk APP_BUILD_SCRIPT=./Android.mk
	cd ..

	if [ "$2" = "gui" ] ; then
		mkdir -p build/apk build/gen build/obj
		mkdir -p build/apk/lib/armeabi-v7a
		cp cpp/libs/armeabi-v7a/libnative-lib.so build/apk/lib/armeabi-v7a
		echo "[*] Compile Java ( generates R.java )"
		"$buildtools"/aapt package -f -m -J build/gen/ -S res -M AndroidManifest.xml -I "$platform/android.jar"
		sleep 1

		echo "[*] Compile Java ( generates *.class )"
		"$java_jdk/bin/javac" -source 1.7 -target 1.7 -bootclasspath "$java_jdk/jre/lib/rt.jar" -classpath "$platform/android.jar" -d build/obj build/gen/com/zenysec/$1/R.java java/com/zenysec/$1/*.java
		sleep 1

		echo "[*] Compile java ( generate *.dex )"
		"$buildtools/dx" --dex --output=build/apk/classes.dex build/obj/

		echo "[*] Package Apk"
		"$buildtools/aapt" package -f -M AndroidManifest.xml -S res/ -I "$platform/android.jar" -F build/$1.unsigned.apk build/apk/

		echo "[*] Align Apk"
		"$buildtools/zipalign" -f -p 4 build/$1.unsigned.apk build/$1.aligned.apk

		echo "[*] Generate Keys"
		"$java_jdk/bin/keytool" -genkeypair -keystore keystore.jks -alias androidkey -validity 10000 -keyalg RSA -keysize 2048 -storepass android -keypass android

		echo "[*] Sign Apk"
		"$buildtools/apksigner" sign --ks keystore.jks --ks-key-alias androidkey --ks-pass pass:android --key-pass pass:android --out build/$1.apk build/$1.aligned.apk
	fi

}

function main(){
	welcome $1 $2
	build_project $1 $2
}

main $1 $2
echo "[*] Done!"
