#!/usr/bin/env bash

function welcome(){
        base64 "misc/logo$(( ( RANDOM %  $(ls misc/ | grep logo | wc -l)  ) ))" --decode
        if [ -z "$1" ]; then
                echo "usage: ./install_configuration.sh project_path"
		exit 1
        fi
	echo "** Android Arm Research **"
}

function install(){
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

	if grep -q "ANDROID_RESEARCH_ENABLE" ~/.bashrc; then
		echo $ANDROID_RESEARCH_HOME
        	find ~/ -maxdepth 1 -type f -name ".*hrc" -exec sed -i "s/ANDROID_RESEARCH_ENABLE=[[:print:]]*/ANDROID_RESEARCH_ENABLE=\"1\"/g" {} \; 
		find ~/ -maxdepth 1 -type f -name ".*hrc" -exec sed -i "s/ANDROID_RESEARCH_HOME=[[:print:]]*/ANDROID_RESEARCH_HOME=${ANDROID_RESEARCH_HOME//\//\\\/}/g" {} \;
		find ~/ -maxdepth 1 -type f -name ".*hrc" -exec sed -i "s/ANDROID_RESEARCH_ENV=[[:print:]]*/ANDROID_RESEARCH_ENV=${ANDROID_RESEARCH_HOME//\//\\\/}\/environment/g" {} \;
		find ~/ -maxdepth 1 -type f -name ".*hrc" -exec sed -i "s/ANDROID_RESEARCH_JDK=[[:print:]]*/ANDROID_RESEARCH_JDK=${ANDROID_RESEARCH_HOME//\//\\\/}\/jdk1.8.0_191/g" {} \;
		find ~/ -maxdepth 1 -type f -name ".*hrc" -exec sed -i "s/ANDROID_RESEARCH_SDK=[[:print:]]*/ANDROID_RESEARCH_SDK=${ANDROID_RESEARCH_HOME//\//\\\/}\/sdk_tools/g" {} \;
		find ~/ -maxdepth 1 -type f -name ".*hrc" -exec sed -i "s/ANDROID_RESEARCH_NDK=[[:print:]]*/ANDROID_RESEARCH_NDK=${ANDROID_RESEARCH_HOME//\//\\\/}\/android-ndk-r18b/g" {} \;
		find ~/ -maxdepth 1 -type f -name ".*hrc" -exec sed -i "s/ANDROID_RESEARCH_NDK_GDB=[[:print:]]*/ANDROID_RESEARCH_NDK_GDB=${ANDROID_RESEARCH_NDK//\//\\\/}\/prebuilt\/linux-x86_64\/bin\/gdb/g" {} \;
		find ~/ -maxdepth 1 -type f -name ".*hrc" -exec sed -i "s/ANDROID_RESEARCH_BUILD_TOOLS=[[:print:]]*/ANDROID_RESEARCH_BUILD_TOOLS=${ANDROID_RESEARCH_SDK//\//\\\/}\/build_tools/g" {} \;
		find ~/ -maxdepth 1 -type f -name ".*hrc" -exec sed -i "s/ANDROID_RESEARCH_PLATFORM_VERSION=[[:print:]]*/ANDROID_RESEARCH_PLATFORM_VERSION=\"android-16\"/g" {} \;
		find ~/ -maxdepth 1 -type f -name ".*hrc" -exec sed -i "s/ANDROID_RESEARCH_PLATFORM=[[:print:]]*/ANDROID_RESEARCH_PLATFORM=${ANDROID_RESEARCH_BUILD_TOOLS//\//\\\/}\/platforms\/$ANDROID_RESEARCH_PLATFORM_VERSION/g" {} \;
	else
		echo "ANDROID_RESEARCH_ENABLE=\"1\"" | tee -a ~/.zshrc ~/.bashrc
		echo "ANDROID_RESEARCH_HOME=$ANDROID_RESEARCH_HOME" | tee -a ~/.zshrc ~/.bashrc
		echo "ANDROID_RESEARCH_ENV=$ANDROID_RESEARCH_HOME/environment" | tee -a ~/.zshrc ~/.bashrc
		echo "ANDROID_RESEARCH_JDK=$ANDROID_RESEARCH_HOME/jdk1.8.0_191" | tee -a ~/.zshrc ~/.bashrc
		echo "ANDROID_RESEARCH_SDK=$ANDROID_RESEARCH_HOME/sdk_tools" | tee -a ~/.zshrc ~/.bashrc
		echo "ANDROID_RESEARCH_NDK=$ANDROID_RESEARCH_HOME/android-ndk-r18b" | tee -a ~/.zshrc ~/.bashrc
		echo "ANDROID_RESEARCH_NDK_GDB=$ANDROID_RESEARCH_NDK/prebuilt/linux-x86_64/bin/gdb" | tee -a ~/.zshrc ~/.bashrc
		echo "ANDROID_RESEARCH_BUILD_TOOLS=$ANDROID_RESEARCH_SDK/build_tools" | tee -a ~/.zshrc ~/.bashrc
		echo "ANDROID_RESEARCH_PLATFORM_VERSION=\"android-16\"" | tee -a ~/.zshrc ~/.bashrc
		echo "ANDROID_RESEARCH_PLATFORM=$ANDROID_RESEARCH_BUILD_TOOLS/platforms/$ANDROID_RESEARCH_PLATFORM_VERSION" | tee -a ~/.zshrc ~/.bashrc
	fi
}

function main(){
        welcome $1
	install $1
}

main $1
echo "[*] Done!"
