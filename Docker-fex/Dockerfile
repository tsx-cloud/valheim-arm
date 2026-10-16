FROM tsxcloud/steamcmd-wine-ntsync:arm64-fex

# SteamCMD (Oct 2026) looks for a native "linuxarm64" steamcmd, which Valve
# never publishes. Force the emulated linux32 binary again.
ENV STEAM_PLATFORM=linux32

# How hard the entrypoint tries to get the server files in (see entrypoint.sh).
ENV STEAMCMD_ATTEMPTS=12
ENV STEAMCMD_TIMEOUT=600

RUN apt update
RUN apt install -y \
        libatomic1 \
        libpulse-dev \
        libpulse0 \
        procps

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
