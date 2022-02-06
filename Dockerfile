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
RUN sudo systemctl restart systemd-binfmt

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh
CMD ["/bin/bash", "/entrypoint.sh"]
