#!/bin/bash

set -ex

if [ -z "$1" ]
then
  echo "Windows ?"
  sed -i '/shopt -s extglob/ {
   r /share/prepare/mb2.windows
   N
  }' /usr/bin/mb2
else
  echo "# preparing buildengine container"

  OLD_UID=$(id -u mersdk) ;\
  OLD_GID=$(id -g mersdk) ;\

  echo "# changing mersdk uid to $1"
  usermod -u $1 mersdk ;\

  echo "# changing mersdk gid to $2"
  groupmod -g $2 mersdk ;\

  echo "# changing gid ownership from $OLD_GID to $2"
  find /home -group $OLD_GID -exec chgrp -h mersdk {} \;

  echo "# changing uid ownership from $OLD_UID to $1"
  find /home -user $OLD_UID -exec chown -h mersdk {} \;
fi

echo "# refreshing repositories"
zypper ref

cp /share/prepare/start.sh /
chmod +x /start.sh

ssh-keygen -A

sudo -u mersdk /bin/bash /share/prepare/install.sh $3

sed -i "s/1024/unlimited/" /etc/security/limits.d/90-nproc.conf
sed -i "s/1024/unlimited/" /srv/mer/targets/SailfishOS-$3-armv7hl/etc/security/limits.d/90-nproc.conf
sed -i "s/1024/unlimited/" /srv/mer/targets/SailfishOS-$3-i486/etc/security/limits.d/90-nproc.conf

echo "# clearing zypper cache"
rm -rf /var/cache/zypp/*
rm -rf /srv/mer/targets/SailfishOS-$3-armv7hl/var/cache/zypp/*
rm -rf /srv/mer/targets/SailfishOS-$3-i486/var/cache/zypp/*

echo "# done!"
