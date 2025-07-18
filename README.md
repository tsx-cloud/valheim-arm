## Base information
The goal of this build is to enable running Valheim with mods, on both arm64 and amd64 platforms.

In the logs folder, you can find startup logs of Valheim on the arm64 platform (Ampere Altra CPU).
The docker-compose-example folder contains a quickstart setup to launch.

Important note! ntsync support is available only in the latest Ubuntu version — 25.04, and even then it must be manually enabled.
The build works perfectly fine without ntsync — the only thing you need to do is comment out the following two lines in your docker-compose file:
```yaml
    #devices:
    #  - /dev/ntsync:/dev/ntsync
```
Autosave works correctly when using docker stop.

## Configuration

### Environment Variables

- `ENABLE_PLUGINS` - enables or disables plugin support(Default: false)
- `SERVER_NAME` - The name of the server as it should appear in the server browser (Default: "Valheim_Server")
- `SERVER_WORLD` - The name of the `.fwl` and `.db` files used to store the world (Default: "tsx_world")
- `SERVER_PASSWORD` - The password to enter the server. Must be 5 characters or longer
- `SERVER_VISIBILITY` - Whether or not to show the server in the server browser (Default: 1)
  - `1` - Visible in browser
  - `0` - Invisible, only joinable by "Join IP"
- `SERVER_SAVE_INTERVAL` - How often the world will save in seconds (Default: 1800)
- `SERVER_BACKUPS` - How many automatic backups will be kept (Default: 4)
- `SERVER_BACKUP_SHORT` - The interval between the first automatic backups (Default: 7200)
- `SERVER_BACKUP_LONG` - The interval between the subsequent automatic backups (Default: 43200)

### Ports

If ports 2456-2458/UDP are in use on your server, you can use a different port range by changing the left side of the port assignment like so:

### ARM
You can set your custom Box64 or Fex-emu configuration in  
`./valheim/persistentdata/settings/emulators.rc`  
This lets you fine-tune the emulator for your specific device or OS.

A list of available environment variables can be found here:  
https://github.com/ptitSeb/box64/blob/main/docs/USAGE.md  
and here (for arm64-fex tag):  
https://github.com/FEX-Emu/FEX/blob/main/FEXCore/Source/Interface/Config/Config.json.in

### Volumes

| Volume             | Container path              | Description                             |
| -------------------- | ----------------------------- | ----------------------------------------- |
| steam install path | /root/valheim-server         | path to hold the dedicated server files |
| world              | /root/.config/unity3d/IronGate/Valheim | path that holds the persistent world files         |

## docker-compose.yml

```yaml
services:
  valheim_server:
    image: tsxcloud/valheim-arm:latest
    restart: unless-stopped
    stop_grace_period: 40s
    ports:
      - "2456:2456/udp"
      - "2457:2457/udp"
      - "2458:2458/udp"
    environment:
      - SERVER_NAME=Valheim_Server
      - SERVER_WORLD=tsx_world
      - SERVER_PASSWORD=123456780
      - ENABLE_PLUGINS=false
    volumes:
      # Bind mount, to access the files directly on the host
      - ./valheim/server/:/root/valheim-server
      - ./valheim/persistentdata/:/root/.config/unity3d/IronGate/Valheim
    #This is required for ntsync to work inside Docker.
    #If ntsync support is not enabled in your Linux kernel, comment out this section, otherwise Docker Compose won't start.
#    devices:
#      - /dev/ntsync:/dev/ntsync
```

## Links
You can find the Docker builds here:
https://hub.docker.com/r/tsxcloud/valheim-arm

## Acknowledgments
https://github.com/husjon/valheim_server_oci_setup  
https://gitlab.com/tedtramonte/valheim-server  
https://github.com/Kron4ek/Wine-Builds       

## 
Enjoying the project? A ⭐ goes a long way!
