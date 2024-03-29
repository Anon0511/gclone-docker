# gclone-docker
[dogbutcat gclone](https://github.com/dogbutcat/gclone) in Docker

[Docker Hub!](https://hub.docker.com/r/anon0511/gclone-docker)

This container is specifically aimed at Google Drive users using Service Accounts. Well, that is pretty much the only reason to use gclone over rclone anyway so I suppose you know.

dogbutcat gclone features some additional very useful things, like `--drive-random-pick-sa`, `--drive-rolling-sa` and `--drive-rolling-count=1`. Please refer to his Git on the link above to check what these options do.


### Pipeline

This container is built automatically with a pipeline on a weekly schedule using alpine:latest and newest version from dogbutcat Release!


## Usage


### docker-compose

```yaml
---
version: '3.9'
services:
  gclone-anime:
    image: anon0511/gclone-docker:latest
    restart: unless-stopped
    container_name: gclone-anime
    environment:
      - TZ=Europe/Berlin
      - "to_path=anime:"
      - from_path=/mnt/google/anime/
      - intvl=60
      - minage=120
      - JOB=move
      - OPTS=--delete-empty-src-dirs --fast-list --drive-random-pick-sa --drive-rolling-sa --drive-rolling-count=1 --filter='- *.!qB'
    volumes:
      - /mnt/google/anime:/mnt/google/anime
      - /home/user/.config/rclone:/var/gclone/.config/rclone
      - /home/user/sarotate/all_accounts:/home/user/sarotate/all_accounts
      - /home/gclone:/gclone
```


## Parameters


| Parameter | Function |
| :----: | --- |
| `TZ=Europe/Berlin` | Specify a timezone to use EG Europe/London. |
| `to_path=anime:/` | The cloud drive's name to upload to, the name must match the name in your rclone.conf. |
| `from_path=/mnt/google/anime/` | Your source directory which you mount from your host system into the container. |
| `intvl=60` | The interval on which gclone starts uploading new data. If left empty it's set to 15 min. |
| `minage=120` | The files must be older than this in minutes to be uploaded. If left empty it's set to the `intvl` time. |
| `JOB=` | Like `move` or `copy` or `sync`. |
| `OPTS=` | Additional rclone Commandline options which are not covered yet. |
| `/mnt/google/anime` | Your source directory, can be anything, must match `from_path=`. |
| `/home/user/.config/rclone` | Your personal rclone directory with the rclone.conf. |
| `/home/user/sarotate/all_accounts` | Your directory with all Service Account files, must match the path configured in the rclone.conf. |
| `/home/gclone` | The directory where gclone writes it's log to, for monitoring and debugging. |


