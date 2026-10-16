FROM tsxcloud/steamcmd-wine-ntsync:latest

RUN apt update
RUN apt install -y \
        libatomic1 \
        libpulse-dev \
        libpulse0 \
        procps

# SteamCMD self-updates on every start, and its Oct 2026 build broke the
# emulated ARM64 flow (full story in entrypoint.sh). This image fixes the two
# build-time pieces, on arm64 only:
#  - the base image ships a box64 too old for the new steamcmd, which imports
#    __sched_cpualloc/__sched_cpufree (wrapped only since ptitSeb/box64#4381,
#    Sep 2026) -> install a current box64 from the same deb repo the base uses
#  - the base image's steamcmd launchers let the new steamcmd.sh look for a
#    native "linuxarm64" steamcmd Valve never ships -> replace them with
#    steamcmd-wrapper.sh, which forces the emulated linux32 binary
COPY steamcmd-wrapper.sh /usr/local/share/steamcmd-wrapper.sh
RUN if [ "$(dpkg --print-architecture)" = "arm64" ]; then \
        apt update && apt install -y box64 && \
        cp /usr/local/share/steamcmd-wrapper.sh /usr/local/bin/steamcmd.sh && \
        cp /usr/local/share/steamcmd-wrapper.sh /usr/local/bin/steamcmd && \
        chmod 775 /usr/local/bin/steamcmd /usr/local/bin/steamcmd.sh; \
    fi

# Belt and suspenders for direct /root/steamcmd/steamcmd.sh calls.
ENV STEAM_PLATFORM=linux32

# How hard the entrypoint tries to get the server files in (see entrypoint.sh).
ENV STEAMCMD_ATTEMPTS=12
ENV STEAMCMD_TIMEOUT=600

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
