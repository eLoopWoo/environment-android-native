#!/usr/bin/env bash

function welcome(){
	if [ -z $ANDROID_RESEARCH_ENABLE ] ; then
		echo "error: \$ANDROID_RESEARCH_ENABLE is not set"
		exit 1
	fi
	
	if [ -z $1 ] || [ -z $2 ] || [ -z $3 ]  ; then
		echo "usage: ./create_project project_name sdk_version cli/gui"
		exit 1
	fi

	if [ "$3" != "cli" ] && [ $3 != "gui" ] ; then
		echo "usage: ./create_project project_name sdk_version cli/gui"
		exit 1
	fi
}

function create_project(){
	echo "[*] Creating Project"
	mkdir -p $ANDROID_RESEARCH_ENV/projects/$1
	cp -r $ANDROID_RESEARCH_ENV/template-project/$3/* $ANDROID_RESEARCH_ENV/projects/$1

	# Fill template
	python $ANDROID_RESEARCH_ENV/scripts/util_create_project.py -n $1 -v $2 -p $ANDROID_RESEARCH_ENV/projects -i $3
}

function main(){
	welcome $1 $2 $3
	create_project $1 $2 $3
}

main $1 $2 $3
echo "[*] Done!"
