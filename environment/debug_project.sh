#!/usr/bin/env bash

function welcome(){
        if [ -z $ANDROID_RESEARCH_ENABLE ] ; then
                echo "error: \$ANDROID_RESEARCH_ENABLE is not set"
                exit 1
        fi

        if [ -z $1 ] || [ -z $2 ] ; then
                echo "usage: ./debug_project project_name cli/gui"
                exit 1
        fi

        if [ "$2" != "cli" ] && [ $2 != "gui" ] ; then
                echo "usage: ./debug_project project_name cli/gui"
                exit 1
        fi

}

function setup_libs(){
	if [ "$2" = "gui" ] ; then
		echo "[*] Copying native libraries to libs/"
		cp $ANDROID_RESEARCH_ENV/projects/$1/build/apk/lib/armeabi-v7a/libnative-lib.so $ANDROID_RESEARCH_ENV/libs
	fi
}

function debug_project(){
	if [ "$2" = "gui" ] ; then
		echo "[*] Launching app"
		local_field=5
		$ANDROID_RESEARCH_BUILD_TOOLS/platform-tools/adb shell am start -n com.zenysec.$1/com.zenysec.$1.MainActivity
		sleep 5
	else
		echo "[*] Launch executable"
		local_field=7
		$ANDROID_RESEARCH_BUILD_TOOLS/platform-tools/adb shell su -x "/data/local/tmp/$1" &> process_output &
		sleep 5
	fi	
	echo "[*] Killing gdbserver instance"
	pid_gdbserver=`$ANDROID_RESEARCH_BUILD_TOOLS/platform-tools/adb shell su -x "ps" | grep gdbserver | head -n1 | cut -d" " -f7`
	cmd_kill_gdbserver="kill -9 $pid_gdbserver"
        $ANDROID_RESEARCH_BUILD_TOOLS/platform-tools/adb shell su -x $cmd_kill_gdbserver
	sleep 2

	app_pid=`$ANDROID_RESEARCH_BUILD_TOOLS/platform-tools/adb shell su -x "ps" | grep $1 | cut -d" " -f$local_field`
	echo "[*] App launched with pid=$app_pid"

	cmd_start_gdbserver="/data/local/tmp/arm-gdbserver :9998 --attach $app_pid"
	echo "[*] Attaching gdbsever: $cmd_start_gdbserver"
	$ANDROID_RESEARCH_BUILD_TOOLS/platform-tools/adb forward tcp:9998 tcp:9998
	$ANDROID_RESEARCH_BUILD_TOOLS/platform-tools/adb shell su -x $cmd_start_gdbserver &

	echo "[*] Launching GDB"
	$ANDROID_RESEARCH_NDK_GDB -x $ANDROID_RESEARCH_ENV/scripts/gdb_plugin.sh
}

function main(){
	welcome $1 $2
	setup_libs $1 $2
	debug_project $1 $2
}

main $1 $2
echo "[*] Done!"
