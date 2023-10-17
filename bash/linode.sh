#!/bin/bash
# RSS feed
RSS_URL="https://status.linode.com/history.atom"

# Define the keyword
KEYWORD=("Frankfurt" "London" "Dallas" "Tokyo" "Paris" "Cloud Manager")
# RSS feed output
output=$(curl --silent "$RSS_URL" | grep -E '(title>|description>)' | tail -n +4 | sed -e 's/^[ \t]*//' | sed -e 's/<title>//' -e 's/<\/title>//' -e 's/<description>/  /' -e 's/<\/description>//')

# Check if RSS feed contains any keywords
if echo "$output" | grep -q "$KEYWORD"; then
    echo "Take a look. Maintenance is happening in $KEYWORD"   
fi
