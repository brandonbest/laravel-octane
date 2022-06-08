#!/bin/bash

# Start Octane
/usr/local/bin/octane-start &

# Start Nginx
/usr/local/bin/nginx-start &

while sleep 180; do
  ps aux |grep php |grep -q -v grep
  PROCESS_1_STATUS=$?
  ps aux |grep nginx |grep -q -v grep
  PROCESS_2_STATUS=$?
  # If the greps above find anything, they exit with 0 status
  # If they are not both 0, then something is wrong
  if [ $PROCESS_1_STATUS -ne 0 -o $PROCESS_2_STATUS -ne 0 ]; then
    echo "One of the processes has already exited."
    exit 1
  fi
done