FROM debian:12-slim

ARG UID=1000
ARG GID=1000

ARG DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture i386 \
  && apt-get update \
  && apt-get -y upgrade \
  && apt-get install -y curl wine xvfb winbind \
  && rm -rf /var/lib/apt/lists/*

RUN groupadd -g ${GID} -o vrising \
  && useradd -m -u ${UID} -g ${GID} -o -s /bin/bash vrising


RUN mkdir -p /home/vrising/.wine/drive_c/SteamCmd \
  && mkdir -p /home/vrising/.wine/drive_c/VRisingData \
  && mkdir -p /home/vrising/.wine/drive_c/VRisingServer \
  && curl https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip | zcat > /home/vrising/.wine/drive_c/SteamCmd/steamcmd.exe \
  && chown -R vrising:vrising /home/vrising/.wine

ENV WINEPATH="C:\\SteamCmd;C:\\VRisingServer" \
  SteamAppId=1604030

ENV GAME_PORT=27015
ENV QUERY_PORT=27016
ENV FALLBACK_PORT=27017
ENV RCON_PORT=25575

USER vrising

WORKDIR /home/vrising

EXPOSE $GAME_PORT/udp
EXPOSE $QUERY_PORT/udp
EXPOSE $FALLBACK_PORT/udp
EXPOSE $RCON_PORT

STOPSIGNAL SIGINT

COPY docker-entrypoint.sh /usr/local/bin
COPY settings settings

ENTRYPOINT [ "docker-entrypoint.sh" ]
