#!/bin/sh

RUAB="/etc/storage/ruantiblock.sh"
RUAB_DIR="/tmp/var/ruab"
RUAB_SRC_REMOTE="https://github.com/spvkgn/ruab/raw/master"
RUAB_SRC_LOCAL="http://192.168.1.75:8080"
RUAB_SRC=$RUAB_SRC_REMOTE

if [ -f "$RUAB" ]; then

  if $RUAB status | head -n 2 | grep -q Active ; then
    $RUAB stop ; $RUAB destroy
  fi

  [ ! -d $RUAB_DIR ] && mkdir -p $RUAB_DIR
  rm -f $RUAB_DIR/*

  for i in update_status ruab.dnsmasq ruab.ip ; do
    while [ ! -s $RUAB_DIR/$i ]; do
      wget $RUAB_SRC/$i.gz -O - | zcat > $RUAB_DIR/$i
    done
  done

  while [ `awk '{printf ( "%2.0f\n", $1/60 ) }' /proc/uptime` -lt 1 ]; do
    sleep 10
  done

  $RUAB start

fi
