#!/bin/bash
TOPIC=$(cat /etc/ntfy-topic)
TITLE="$1"
MESSAGE="$2"
curl -s \
  -H "Title: $TITLE" \
  -H "Priority: high" \
  -H "Tags: warning" \
  -d "$MESSAGE" \
  "https://ntfy.sh/$TOPIC" > /dev/null
