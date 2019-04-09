#!/usr/bin/env bash


function welcome(){
	base64 "misc/logo$(( ( RANDOM %  $(ls misc/ | grep logo | wc -l)  ) ))" --decode
	echo "** Android Arm Research **"
}

function download_sdk(){
	echo "[*] Downloading SDK..."
	# https://dl.google.com/android/repository/repository-11.xml

	wget https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip --append-output $1
	unzip -qq sdk-tools-linux-4333796.zip
	mv tools/ sdk_tools
	rm sdk-tools-linux-4333796.zip

	wget https://dl.google.com/android/repository/build-tools_r28.0.3-linux.zip --append-output $1
	unzip -qq build-tools_r28.0.3-linux.zip
	mv android-9/ sdk_tools/build_tools
	rm build-tools_r28.0.3-linux.zip

	wget https://dl.google.com/android/repository/platform-tools_r28.0.1-linux.zip --append-output $1
	unzip -qq platform-tools_r28.0.1-linux.zip
	mv platform-tools sdk_tools/build_tools
	rm platform-tools_r28.0.1-linux.zip

	wget https://dl.google.com/android/repository/android-16_r05.zip --append-output $1
	unzip -qq android-16_r05.zip
	mkdir -p sdk_tools/build_tools/platforms
	mv android-4.1.2 sdk_tools/build_tools/platforms/android-16
	rm android-16_r05.zip
}

function download_jdk(){
	echo "[*] Donwloading JDK..."
	wget --no-cookies \
	--no-check-certificate \
	--header "Cookie: oraclelicense=accept-securebackup-cookie" \
	http://download.oracle.com/otn-pub/java/jdk/8u191-b12/2787e4a523244c269598db4e85c51e0c/jdk-8u191-linux-x64.tar.gz \
	-O jdk-8u191-linux-x64.tar.gz --append-output $1

	tar -xf jdk-8u191-linux-x64.tar.gz
	rm jdk-8u191-linux-x64.tar.gz
}

function download_ndk(){
	echo "[*] Downloading NDK..."
	wget https://dl.google.com/android/repository/android-ndk-r18b-linux-x86_64.zip \
	-O ndk-r18n-linux-x86_64.zip --append-output $1
	unzip -qq ndk-r18n-linux-x86_64.zip
	rm ndk-r18n-linux-x86_64.zip
}

function edit_sdk(){
	echo "[*] Editing dx & apksigner"
	sed -i 's/exec java \$javaOpts -jar \"\$jarpath\" \"\$@\"/exec \$ANDROID_RESEARCH_JDK\/bin\/java \$javaOpts -jar \"\$jarpath\" \"\$@\"/g' sdk_tools/build_tools/apksigner
	sed -i 's/exec java \$javaOpts -jar \"\$jarpath\" \"\$@\"/exec \$ANDROID_RESEARCH_JDK\/bin\/java \$javaOpts -jar \"\$jarpath\" \"\$@\"/g' sdk_tools/build_tools/dx
}

function download(){
	download_jdk $1
	download_ndk $1
	download_sdk $1
}

function main(){	
	welcome
	log_file=".setup_log_$(date +%Y-%m-%d_%H:%M)"
	download $log_file
}

main
echo "[*] Done!"
