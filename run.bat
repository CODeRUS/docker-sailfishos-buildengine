set SDKDIR=C:\SailfishOS
set SCRDIR=%~dp0

set IMAGE_NAME=buildengine-sdk
set CONTAINER_NAME=buildengine-sdk-instance

docker run -it --rm ^
 --name "%CONTAINER_NAME%" ^
 --publish 2222:2222 ^
 --publish 8080:8080 ^
 --volume "%userprofile%:/home/mersdk/share" ^
 --volume "%userprofile%:/home/src1" ^
 --volume "%SDKDIR%\mersdk\ssh:/etc/ssh/authorized_keys" ^
 --volume "%SDKDIR%\mersdk\targets:/host_targets" ^
 --volume "%SDKDIR%\vmshare:/etc/mersdk/share" ^
 --workdir "/home/mersdk/share" ^
 "%IMAGE_NAME%" ^
 "/start.sh"
