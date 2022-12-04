# gclone-docker
[dogbutcat gclone](https://github.com/dogbutcat/gclone) in Docker

This container is specifically aimed at Google Drive users using Service Accounts. Well, that is pretty much the only reason to use gclone over rclone anyway so I suppose you know.

dogbutcat gclone features some additional very useful things, like `--drive-random-pick-sa`, `--drive-rolling-sa` and `--drive-rolling-count=1`. Please refer to his Git on the link above to check what these options do.

Although, this container uses exactly these flags since it is the most logically thing to do to spread API hits and file owner's as much as possible. 

The container has a hardcoded filter for `.!qB`. This is a flag you can configure in qBittorrent to be added to unfinished Torrents, so these won't be uploaded. You can either ignore it if you aren't using qBit or you might want to start using it.

If there is need to actually allow custom filters I might think about it or you open a PR.


## Usage


### docker-compose

```yaml
---
version: '3.9'
services:
  gclone-anime:
    image: anon0511/gclone:latest
    restart: unless-stopped
    container_name: gclone-anime
    environment:
      - to_path=anime:/
      - from_path=/mnt/google/anime/
      - TZ=Europe/Berlin
      - intvl=60
      - minage=120
    volumes:
      - /mnt/google/anime:/mnt/google/anime
      - /home/user/.config/rclone:/var/gclone/.config/rclone
      - /home/user/sarotate/all_accounts:/home/user/sarotate/all_accounts
      - /home/gclone:/gclone
```


## Parameters


| Parameter | Function |
| :----: | --- |
| `PUID=1000` | for UserID - see below for explanation. |
| `PGID=1000` | for GroupID - see below for explanation. |
| `TZ=Europe/Berlin` | Specify a timezone to use EG Europe/London. |
| `to_path=anime:/` | The cloud drive's name to upload to, the name must match the name in your rclone.conf. |
| `from_path=/mnt/google/anime/` | Your source directory which you mount from your host system into the container. |
| `intvl=60` | The interval on which gclone starts uploading new data. If left empty it's set to 15 min. |
| `minage=120` | The files must be older than this in minutes to be uploaded. If left empty it's set to the `intvl` time. |
| `/mnt/google/anime` | Your source directory, can be anything, must match `from_path=`. |
| `/home/user/.config/rclone` | Your personal rclone directory with the rclone.conf. |
| `/home/user/sarotate/all_accounts` | Your directory with all Service Account files, must match the path configured in the rclone.conf. |
| `/home/gclone` | The directory where gclone writes it's log to, for monitoring and debugging. |


## User / Group Identifiers

When using volumes (`-v` flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1000` and `PGID=1000`, to find yours use `id user` as below:

```bash
  $ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```

