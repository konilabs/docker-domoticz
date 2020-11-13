FROM debian:buster-slim
LABEL maintainer="Nicolas PERRIN nicolas@perrin.in"
ARG DOMOTICZ_VERSION="2020.2"

# Install cmake from backports
RUN echo 'deb http://deb.debian.org/debian buster-backports main' > /etc/apt/sources.list.d/backports.list \
    && apt-get update \
    && apt-get -y -t buster-backports install cmake \
    && apt-get install -y make gcc g++ libssl-dev git libcurl4-gnutls-dev libusb-dev python3-dev zlib1g-dev libudev-dev libboost-all-dev libcereal-dev liblua5.3-dev uthash-dev python-pip

# Install python modules
RUN pip install requests

# Build openzwave
RUN mkdir /src \
    && cd /src \
    && git clone --depth 1 https://github.com/OpenZWave/open-zwave open-zwave-read-only \
    && cd open-zwave-read-only \
    && make \
    && make install

# Build domoticz
RUN cd /src \
    && git clone --depth 1 -b ${DOMOTICZ_VERSION} https://github.com/domoticz/domoticz.git domoticz \
    && cd domoticz \
    && cmake -DCMAKE_BUILD_TYPE=Release CMakeLists.txt \
    && make -j 3  

# Cleanup container
RUN apt-get remove -y cmake make gcc g++ libssl-dev git zlib1g-dev libudev-dev libboost-all-dev libcereal-dev liblua5.3-dev uthash-dev \
    && apt-get autoremove -y \ 
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ADD docker-entrypoint.sh /entrypoint.sh

EXPOSE 8080
VOLUME ["/config"]
ENTRYPOINT ["/entrypoint.sh"]
CMD [""]