#!/bin/sh

trap '/shutdown.sh' SIGTERM

cd /server

java -Xmx1024M -Xms512M -jar server.jar nogui

