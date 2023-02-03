#!/bin/sh

# Check for still running process

if pidof -o %PPID "gclone_start.sh"; then
  echo "gclone is still running"
  exit 1
fi

# Variables

LOGFILE="/gclone/$(echo $to_path | cut -d: -f1)_$JOB.log"
UPJOB=$(echo $JOB | tr '[:lower:]' '[:upper:]')

if [ -z "$minage" ]
then
  minage=$intvl
  echo "setting minage : $intvl"
fi


if ! gclone listremotes | grep -Fq $from_path
then
  if find $from_path -type f -mmin +$MINAGE ! -name '*.!qB' | read
  then
    start=$(date +'%s')
    echo "$(date "+%d.%m.%Y %T") RCLONE $UPJOB STARTED" | tee -a $LOGFILE
    eval /usr/bin/gclone $JOB "$from_path" "$to_path" --min-age ${minage}m --log-level=INFO --log-file=$LOGFILE $OPTS
    echo "$(date "+%d.%m.%Y %T") RCLONE $UPJOB FINISHED IN $(($(date +'%s') - $start)) SECONDS" | tee -a $LOGFILE
  else
    echo "Nothing to $JOB"
  fi
else
  start=$(date +'%s')
  echo "$(date "+%d.%m.%Y %T") RCLONE $UPJOB STARTED" | tee -a $LOGFILE
  eval /usr/bin/gclone $JOB "$from_path" "$to_path" --min-age ${minage}m --log-level=INFO --log-file=$LOGFILE $OPTS
  echo "$(date "+%d.%m.%Y %T") RCLONE $UPJOB FINISHED IN $(($(date +'%s') - $start)) SECONDS" | tee -a $LOGFILE
fi

exit
