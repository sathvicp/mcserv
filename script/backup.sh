#!/bin/sh

function rcon {
  /tools/mcrcon -H "$SERVER_HOST" -P 25575 -p "$MCRCON_PWD" "$1"
}

rcon "save-off"
rcon "save-all"
tar -cvpzf /backups/server-$(date +%F-%H-%M).tar.gz /server
rcon "save-on"

## Delete older backups
find /backups/ -type f -mtime +7 -name '*.gz' -delete

