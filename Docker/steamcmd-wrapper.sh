#!/bin/bash
# Wrapper installed over the base image's steamcmd launchers on arm64.
# SteamCMD's launcher (steamcmd.sh) prefers a native "linuxarm64" steamcmd
# that Valve never publishes, and otherwise lets bash exec the 32bit binary
# directly, which fails with "Exec format error" under emulation. Point it
# back to the emulated linux32 binary and make it launch through box64.
# Both defaults can be overridden (e.g. DEBUGGER=gdb to debug steamcmd).
: "${STEAM_PLATFORM:=linux32}"
: "${DEBUGGER:=box64}"
export STEAM_PLATFORM DEBUGGER
exec /root/steamcmd/steamcmd.sh "$@"
