# Sailfish SDK buildengine docker scripts

Scripts are tested only at Ubuntu 19.04

## Build

* Install official Sailfish SDK

* Execute `bash build.sh 3.0.3.9`

  where `3.0.3.9` is Sailfish SDK version you want to use

## Run

* Stop VirtualBox Build Engine machine, if running

* Copy `helpers/VBoxManage` to `$PATH`

* Make it executable (`chmod +x`)

* Start Sailfish SDK

## TL'DR

#### Latest Sailfish SDK should be installed before executing any of these scripts!

`build.sh` script is using `coderus/sailfishos-baseimage` docker image to build sdk buildengine from scratch

`run.sh` script is staring `buildengine-sdk` docker image

### build

Inside `build` directory you can find kickstart scripts and helpers to build Sailfish SDK Build Engine with correct Tooling and Targets using official Jolla public repositories.

Your current user id (`id -u`) and gid (`id -g`) will be used to modify `mersdk` user uid and gid inside buildengine container, to be able to write to your local filesystem.

### prepare

Inside `prepare` directory you can find helper scripts for preparing sdk container to be used instead of virtualbox machine.

### helpers

Inside `helpers` directory you can find `VBoxManage` script, which is responsible for faking Sailfish SDK checks for running `Sailfish OS Build Engine` virtual machine.

Please edit script content (`CONTAINER_RUN_SCRIPT` line) to point to correct `run.sh` script location. This script will start docker image and kill it when SDK wants to do so.

Please copy `VBoxManage` to your `$PATH` location (`.local/bin` for example), so it can be launched by Sailfish SDK instead of original `vboxmanage` executable.

## Thanks to

SfietKonstantin (https://github.com/SfietKonstantin/docker-sailfishos-sdk)

evilJazz (https://github.com/evilJazz/sailfishos-buildengine)

## See also

sailfishos-baseimage (https://hub.docker.com/r/coderus/sailfishos-baseimage/)