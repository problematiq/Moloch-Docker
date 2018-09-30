#!/bin/bash
##################################
#
#  STARTUP SCRIPT FOR Moloch
#
##################################

# Start the capture service.
/data/moloch/bin/moloch-capture -n $node_name -c /data/moloch/etc/config.ini >> /data/moloch/logs/capture.log 2>&1 &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start Capture service: $status"
  exit $status
fi

# Start the Viewer service.
/data/moloch/bin/node /data/moloch/viewer/viewer.js -c /data/moloch/etc/config.ini >> /data/moloch/logs/viewer.log 2>&1 &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start Viewer service: $status"
  exit $status
fi

# Checks once a minute to see if either of the processes exited.
# The container exits with an error if it detects that either of the processes has exited.
# Otherwise it loops forever, waking up every 60 seconds. When paired with a docker restart policy,
# this works well for auto error correction in case one process commits sepaku.

while sleep 60; do
  ps aux |grep /data/moloch/bin/moloch-capture |grep -q -v grep
  PROCESS_1_STATUS=$?
  ps aux |grep /data/moloch/bin/node |grep -q -v grep
  PROCESS_2_STATUS=$?
  # If the greps above find anything, they exit with 0 status
  # If they are not both 0, then something is wrong
  if [ $PROCESS_1_STATUS -ne 0 -o $PROCESS_2_STATUS -ne 0 ]; then
    echo "One of the processes has exited, shutting down container"
    exit 1
  fi
done

exec "$@"
