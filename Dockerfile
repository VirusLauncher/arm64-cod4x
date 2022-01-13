FROM arm64v8/debian:buster-slim

LABEL author="Kris Dookharan" maintainer="krisdookharan15@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

## add container user
RUN useradd -m -d /home/container -s /bin/bash container

RUN ln -s /home/container/ /nonexistent

ENV USER=container HOME=/home/container

## update base packages
RUN apt update \
 && apt upgrade -y

## install dependencies
RUN apt install -y gcc g++ libgcc1-arm64-cross lib32gcc1-amd64-cross libc++-dev gdb libc6 wget curl tar zip unzip binutils xz-utils liblzo2-2 cabextract iproute2 net-tools netcat telnet libatomic1-arm64-cross libsdl1.2debian libsdl2-2.0-0 \
    libfontconfig libicu63 icu-devtools libunwind8 libssl-dev sqlite3 libsqlite3-dev libmariadbclient-dev libduktape203 locales ffmpeg gnupg2 apt-transport-https software-properties-common ca-certificates tzdata \
    liblua5.3 libz3-4 rapidjson-dev git build-essential cmake python3 musl

## install box64
RUN git clone https://github.com/ptitSeb/box64 && \
    cd box64/ && mkdir build && cd build && \
    cmake .. -DARM_DYNAREC=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo && make -j$(nproc) && \
    make install && \
    cd / && rm -rf /box64/ && \
    apt -y purge build-essential cmake python3 && rm -rf /var/lib/apt/lists/*

## configure locale
RUN update-locale lang=en_US.UTF-8 \
 && dpkg-reconfigure --frontend noninteractive locales

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh
CMD ["/bin/bash", "/entrypoint.sh"]
