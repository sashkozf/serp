#!/bin/bash
# RSS feed
RSS_URL="https://status.hetzner.com/en.atom"

# Define the Slack webhook URL
SLACK_WEBHOOK_URL="YOUR_SLACK_WEBHOOK_URL"

# Define the keyword
KEYWORDS=("Frankfurt" "Helsinki" "FSN1-DC1" "FSN1-DC3" "FSN1-DC6" "FSN1-DC7" "FSN1-DC8" "FSN1-DC10" "FSN1-DC11" "FSN1-DC12" "FSN1-DC13" "FSN1-DC15" "FSN1-DC16" "FSN1-DC17" "FSN1-DC18" "HEL1-DC1" "HEL1-DC2" "HEL1-DC3" "HEL1-DC4" "HEL1-DC6" "NBG1-DC5")

# File to store previously sent keywords
SENT_KEYWORDS_FILE="sent_keywords.txt"

# RSS feed output
output=$(curl --silent "$RSS_URL" | grep -E '(title>|description>)' | tail -n +4 | sed -e 's/^[ \t]*//' | sed -e 's/<title>//' -e 's/<\/title>//' -e 's/<description>/  /' -e 's/<\/description>//')

# Check if RSS feed contains any keywords and if they haven't been sent before
for keyword in "${KEYWORDS[@]}"; do
    if echo "$output" | grep -q "$keyword" && ! grep -Fxq "$keyword" "$SENT_KEYWORDS_FILE"; then
        # Send the message to Slack
        message="Take a look. Maintenance is happening in $keyword"
        payload="payload={\"text\": \"$message\"}"
        curl -X POST --data-urlencode "$payload" "$SLACK_WEBHOOK_URL"
        # Append the keyword to the list of sent keywords
        echo "$keyword" >> "$SENT_KEYWORDS_FILE"
    fi
done

