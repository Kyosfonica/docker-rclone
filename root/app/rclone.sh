#!/usr/bin/with-contenv sh

(
  flock -n 200 || exit 1

  command="rclone copy --transfers=2 --checkers=8 --size-only --bwlimit=9M /data $SYNC_DESTINATION:/'$SYNC_DESTINATION_SUBPATH'"

  if [ "$COMMAND" ]; then
  command="$COMMAND"
  else
    if [ -z "$DESTINATION" ]; then
      echo "Error: DESTINATION environment variable was not passed to the container."
      exit 1
    fi
  fi

  echo "Executing => $command"
  eval "$command"
) 200>/var/lock/rclone.lock
