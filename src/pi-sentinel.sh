#!/bin/bash

PI_HOST="pi-edge.local"
STATE_FILE="/tmp/pi_fail_count"
THRESHOLD=6

# Manual kill switch
DISABLE_FILE="$HOME/.pi-sentinel-disabled"
[ -f "$DISABLE_FILE" ] && exit 0

# Check Pi presence
if /bin/ping -c 1 -W 2 "$PI_HOST" >/dev/null 2>&1; then
  echo 0 > "$STATE_FILE"
  exit 0
fi

# Increment failure count
COUNT=$(cat "$STATE_FILE" 2>/dev/null || echo 0)
COUNT=$((COUNT + 1))
echo "$COUNT" > "$STATE_FILE"

# Shutdown condition
if [ "$COUNT" -ge "$THRESHOLD" ]; then
  /usr/bin/logger "pi-sentinel: Pi unreachable for $COUNT checks, shutting down Mac"
  /sbin/shutdown -h now
fi
