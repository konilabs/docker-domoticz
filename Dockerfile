FROM debian:stretch-slim
MAINTAINER Nicolas PERRIN "nicolas@perrin.in"

ENV TIMEZONE Europe/Paris
ENV PYPACKAGES requests 

# Installing packages
RUN apt-get update \
    && apt-get install -y cmake make gcc g++ libssl-dev git libcurl4-gnutls-dev libusb-dev python3-dev python3-pip zlib1g-dev libudev-dev libboost-all-dev

# Build openzwave
RUN mkdir /src \
    && cd /src \
    && git clone https://github.com/OpenZWave/open-zwave open-zwave-read-only \
    && cd open-zwave-read-only \
    && make

# Build domoticz
RUN cd /src \
    && git clone -b master https://github.com/domoticz/domoticz.git domoticz \
    && cd domoticz \
    && cmake -DCMAKE_BUILD_TYPE=Release CMakeLists.txt \
    && make -j 3  

# Upgrading Pip
# RUN apt-get install python3-pip
RUN pip3 install --upgrade pip

# Cleanup container
RUN apt-get remove -y cmake make gcc g++ libssl-dev git zlib1g-dev libudev-dev libboost-all-dev \
    && apt-get autoremove -y \ 
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Backup script directory
RUN mkdir /src/scripts-default \
    && cp -r /src/domoticz/scripts/* /src/scripts-default

ADD docker-entrypoint.sh /entrypoint.sh

EXPOSE 8080
VOLUME ["/config", "/src/domoticz/scripts"]
ENTRYPOINT ["/entrypoint.sh"]
CMD [""]
