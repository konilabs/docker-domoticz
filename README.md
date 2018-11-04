# Domoticz for Docker

Run [Domoticz][] home automation in a Docker container.

Container is based on debian stretch. Domoticz and Openzwave are built from source

[Domoticz]: http://www.domoticz.com

## Prerequisites

1. Install [Docker][].

[Docker]: http://docker.com/

## Running

This container exposes port `8080` for Domoticz. This port is HTTP, if you need HTTPS, please use a reverse proxy like Nginx.

Container exposes also `config` folder which contains three subfolders :

`db-log` contains domoticz database (domoticz.db) and log file (domoticz.log)

`default-cfg` contains all domoticz default configuration files. This folder is updated each time container is started. Do not put any user parameters in this folder.

`add-cfg` contains all user configuration. All files in this folder overwrites default configuration files from Domoticz. To modify a configuration file, copy it from default-cfg to add-cfg folder. Edit the file in add-cfg folder. At next container start, it will be used by Domoticz.

Default command line should look like this :

    docker run -ti -p 8080:8080 --name my-domoticz-container -v myvolume:/config konilabs/domoticz
