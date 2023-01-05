#!/bin/sh

# Check for still running process

if pidof -o %PPID "gclone_start.sh"; then
  echo "gclone is still running"
  exit 1
fi

# Variables

FROM=$from_path
TO=$to_path
LOGFILE="/gclone/$(echo $to_path | cut -d: -f1).log"

if [ -z "$minage" ]
then
  minage=$intvl
  echo "setting minage : $intvl"
fi

# Check for files older than x

if find $FROM* -type f -mmin +$MINAGE ! -name '*.!qB' | read
  then
  start=$(date +'%s')
  echo "$(date "+%d.%m.%Y %T") RCLONE UPLOAD STARTED" | tee -a $LOGFILE
  /usr/bin/gclone $JOB "$FROM" "$TO" --filter='- *.!qB' --min-age ${minage}m --log-level=INFO --log-file=$LOGFILE $OPTS
  echo "$(date "+%d.%m.%Y %T") RCLONE UPLOAD FINISHED IN $(($(date +'%s') - $start)) SECONDS" | tee -a $LOGFILE
else
  echo "Nothing to upload"
fi

exit
