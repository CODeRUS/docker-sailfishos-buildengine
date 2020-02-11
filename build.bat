set SDKDIR=C:\SailfishOS
set SCRDIR=%~dp0

set BASEIMAGE="coderus/sailfishos-baseimage"
set RELEASE="3.2.1.20"

echo "# RELEASE: %RELEASE%"

docker run --rm -it ^
 --privileged ^
 --volume "%SCRDIR%:/share" ^
 --workdir "/share" ^
 "coderus/sailfishos-baseimage" ^
 "/bin/bash" "/share/build/build-all.sh" "%RELEASE%"

set IMAGE_BASE_NAME=buildengine-base

docker import ^
 artifacts/buildengine-i486.tar ^
 "%IMAGE_BASE_NAME%"

set IMAGE_SDK_NAME=buildengine-sdk
set CONTAINER_NAME=buildengine-prepare

docker run -it ^
 --name "%CONTAINER_NAME%" ^
 --cap-add SYS_PTRACE ^
 --volume "%userprofile%:/home/mersdk/share" ^
 --volume "%userprofile%:/home/src1" ^
 --volume "%SDKDIR%\mersdk\ssh:/etc/ssh/authorized_keys" ^
 --volume "%SDKDIR%\mersdk\targets:/host_targets" ^
 --volume "%SDKDIR%\vmshare:/etc/mersdk/share" ^
 --volume "%SCRDIR%:/share" ^
 --workdir "/share" ^
 "%IMAGE_BASE_NAME%" ^
 "/bin/bash" "/share/prepare/prepare.sh" "" "" "%RELEASE%"

docker commit ^
 -p ^
 -c "USER mersdk" ^
 -c "WORKDIR /home/mersdk" ^
 -c "CMD [/start.sh]" ^
 -c "EXPOSE 2222" ^
 -c "EXPOSE 8080" ^
 "%CONTAINER_NAME%" "%IMAGE_SDK_NAME%"

docker rm "%CONTAINER_NAME%"
docker rmi "%IMAGE_BASE_NAME%"
