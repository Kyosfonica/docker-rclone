#!/usr/bin/with-contenv sh

(
  if [[ $2 ]]; then
    echo "Info: Reporting job success to health check endpoint"
    curl -fsS --retry 3 $2
  fi

  if [[ "$HEARTBEAT_URL" ]]; then
    echo "Info: Reporting job success to health check endpoint"
    curl --retry 3 $HEARTBEAT_URL
  fi

  flock -n 200 || exit 1

  command = "rclone copy --transfers=2 --checkers=8 --size-only --bwlimit=8.68M /data $SYNC_DESTINATION:/'$SYNC_DESTINATION_SUBPATH'"

  if [[ $1 ]]; then
    command = $1
  else
    if [[ -z "$DESTINATION" ]]; then
      echo "Error: DESTINATION environment variable was not passed to the container."
      exit 1
    fi
  fi

  echo "Executing => $command"
  eval "$command"
) 200>/var/lock/rclone.lock
