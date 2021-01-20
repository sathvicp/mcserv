#!/bin/sh

echo "Shutting down the server..."

/tools/mcrcon -H "localhost" -P 25575 -p "$MCRCON_PWD" stop

