#!/bin/bash
# RSS feed
RSS_URL="https://status.latitude.sh/history.atom"

# Define the keyword
KEYWORDS=("Ashburn" "New York" "Dallas" "Tokyo")

# RSS feed output
output=$(curl --silent "$RSS_URL" | grep -E '(title>|description>)' | tail -n +4 | sed -e 's/^[ \t]*//' | sed -e 's/<title>//' -e 's/<\/title>//' -e 's/<description>/  /' -e 's/<\/description>//')

# Check if RSS feed contains any keywords
for keyword in "${KEYWORDS[@]}"; do
    if echo "$output" | grep -q "$keyword"; then
        echo "Take a look. Maintenance is happening in $keyword"
    fi
done
