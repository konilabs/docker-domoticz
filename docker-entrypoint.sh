#! /usr/bin/env bash

# Create and clean default directories
if [ ! -d "/config/default-cfg" ]; then
  echo "Creating default-cfg in /config volume"
  mkdir /config/default-cfg
fi
rm -rf /config/default-cfg/*

if [ ! -d "/config/db-log" ]; then
  echo "Creating db-log in /config volume"
  mkdir /config/db-log
fi

if [ ! -d "/config/add-cfg" ]; then
  echo "Creating add-cfg in /config volume"
  mkdir /config/add-cfg
fi

# Populating scripts
echo "Populating script volume"
cp -n -r /src/scripts-default/* /src/domoticz/scripts

# Set Timezone
if [ -e /usr/share/zoneinfo/$TIMEZONE ]
then
	echo "Setting Timezone to $TIMEZONE" 
else
	echo "Timezone $TIMEZONE does not exist, setting to Etc/UTC as default"
	export TIMEZONE=Etc/UTC
fi

unlink /etc/localtime
ln -s /usr/share/zoneinfo/$TIMEZONE /etc/localtime

# Populating default configuration
cp -r /src/domoticz/Config/* /config/default-cfg

# Adding user modifications to configuration
if [ "$(ls -A /config/add-cfg/)" ]; then
    echo "User configuration found in add-cfg, copy it to Domoticz"
	cp -rf /config/add-cfg/* /src/domoticz/Config
fi

# Setting PYTHONPATH to allow pip modules import
export PYTHONPATH=/usr/local/lib/$(readlink $(which python3))/dist-packages/

# Installing Pip packages
echo "Installing PIP packages"
pip3 install $PYPACKAGES

echo "Starting Domoticz..."
# exec /bin/bash
exec /src/domoticz/domoticz -dbase /config/db-log/domoticz.db -log /config/db-log/domoticz.log -www 8080