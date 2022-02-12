FROM arm64v8/debian:buster-slim

LABEL author="Kris Dookharan" maintainer="krisdookharan15@gmail.com"

## add container user
RUN useradd -m -d /home/container -s /bin/bash container

RUN ln -s /home/container/ /nonexistent

ENV USER=container HOME=/home/container

RUN apt update \
 && apt upgrade -y

## install dependencies
RUN apt update && apt full-upgrade -y
RUN apt install -y gcc-arm-linux-gnueabihf git make cmake python3 curl libsdl2-2.0-0 nano locales build-essential
RUN apt install -y libc6:arm64 libncurses5:arm64 libstdc++6:arm64

## install box64
RUN git clone https://github.com/ptitSeb/box64 && \
    cd box64/ && mkdir build && cd build && \
    cmake .. -DARM_DYNAREC=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo && make -j$(nproc) && \
    make install && \
    cd / && rm -rf /box64/ && \
    rm -rf /var/lib/apt/lists/*

## configure locale
RUN update-locale lang=en_US.UTF-8 \
 && dpkg-reconfigure --frontend noninteractive locales

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh
CMD ["/bin/bash/box64", "/entrypoint.sh"]
