# environment-android-native
Research environment for android arm jni applications

### Synopsis

The project is set of script and tools that help to achive an efficient r&d environemnt,
creating, building, testing and debugging JNI Android applications.

### Motivation

Couriosity dive to arm, android, jni and android apps secuirty...

## Getting Started

Check 'Prerequisities' section and follow the instruction of 'Installing' section!

### Prerequisities

What things you need

```
Linux Ubuntu/Debian x86-64
git
```

### Installing
A step by step series of examples that tell you have to get a development env running, `$repo_root` is the
top directory of this repository

`setup.sh` will the necessary kits install ndk, jdk, sdk

Reccomended to use `install_configuration.sh` for persistent environment variables,
use `configure.sh` to set environment variables only for the current shell.


## Example Use
The project consists mostly bash scripts you just run to automate development cycles.

* setup.sh


Download and install necessary kits to current folder

* install_configuration.sh


Set persistent environment variables

`usage: ./install_configuration.sh project_path`

* create_project


Create new project, starting with template found in `template-project/`

`usage: ./create_project project_name sdk_version cli/gui`

* build_project.sh


Using the kits, build the project

`usage: ./build_project project_name cli/gui`

* install_project.sh


Use adb to install the project into physical device

`usage: ./install_project project_name cli/gui`

* debug_project.sh


Deubg project on physical device

`usage: ./debug_project project_name cli/gui`




