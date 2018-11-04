#! /usr/bin/env bash

mkdir /config/default-cfg
mkdir /config/db-log
mkdir /config/add-cfg

# Populating default configuration
cp -r /src/domoticz/Config/* /config/default-cfg
# Adding user modifications to configuration
cp -rf /config/add-cfg/* /src/domoticz/Config

echo "Starting Domoticz..."
# exec /bin/bash
exec /src/domoticz/domoticz -dbase /config/db-log/domoticz.db -log /config/db-log/domoticz.log -www 8080