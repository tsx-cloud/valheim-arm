FROM tsxcloud/steamcmd-wine-ntsync:10.13-arm64-fex

RUN apt update
RUN apt install -y \
        libatomic1 \
        libpulse-dev \
        libpulse0

ENV ENABLE_PLUGINS="false"
ENV SERVER_NAME="Valheim_Server"
ENV SERVER_WORLD="tsx_world"
ENV SERVER_PASSWORD=
ENV SERVER_VISIBILITY=1
ENV SERVER_SAVE_INTERVAL=1800
ENV SERVER_BACKUPS=4
ENV SERVER_BACKUP_SHORT=7200
ENV SERVER_BACKUP_LONG=43200

WORKDIR /root

COPY server/ defaults/server/

COPY emulators.rc .

COPY --chmod=775 load_emulators_env.sh /load_emulators_env.sh

COPY --chmod=775 print_app_versions.sh /print_app_versions.sh

COPY --chmod=775 entrypoint.sh ./

ENTRYPOINT ["./entrypoint.sh"]
