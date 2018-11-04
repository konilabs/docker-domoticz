FROM debian:stretch-slim
MAINTAINER Nicolas PERRIN "nicolas@perrin.in"

# Installing packages
RUN apt-get update \
    && apt-get install -y cmake make gcc g++ libssl-dev git libcurl4-gnutls-dev libusb-dev python3-dev zlib1g-dev libudev-dev libboost-all-dev

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

# Cleanup container
RUN apt-get remove -y cmake make gcc g++ libssl-dev git zlib1g-dev libudev-dev libboost-all-dev \
    && apt-get autoremove -y \ 
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

VOLUME /config
EXPOSE 8080
ENTRYPOINT ["/entrypoint.sh"]