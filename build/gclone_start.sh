#!/bin/sh

# Check for still running process

if pidof -o %PPID "gclone_start.sh"; then
  # echo "killing myself as gclone_start.sh is running "
  exit 1
fi

# Variables

FROM=$from_path
TO=$to_path
MINAGE=$minage
LOGFILE="/gclone/$(echo $to_path | cut -d: -f1).log"

if [ -z "$minage" ]
then
  MINAGE=$intvl
  echo "setting minage : $intvl"
else
  echo "minage: $MINAGE"
fi

# Check for files older than x

if find $FROM* -type f -mmin +$MINAGE ! -name '*.!qB' | read
  then
  start=$(date +'%s')
  echo "$(date "+%d.%m.%Y %T") RCLONE UPLOAD STARTED" | tee -a $LOGFILE
  /usr/bin/gclone move "$FROM" "$TO" --filter='- *.!qB' --delete-empty-src-dirs --min-age ${MINAGE}m --fast-list --drive-random-pick-sa --drive-rolling-sa --drive-rolling-count=1 --log-level=INFO --log-file=$LOGFILE
  echo "$(date "+%d.%m.%Y %T") RCLONE UPLOAD FINISHED IN $(($(date +'%s') - $start)) SECONDS" | tee -a $LOGFILE
fi

exit
