#!/bin/bash
# RSS feed
RSS_URL="https://bare-metal-servers.status-ovhcloud.com/history.atom"

# Define the keywords
KEYWORDS=("LIM0313A03B" "LIM0312A04C" "LIM0314B03B" "LIM0314A04C" "LIM0313A05C" "LIM0313A02B" "L107A11" "LIM0311B04A" "L122B04" "GRA0326B05C" "L114A20" "L122B12" "L122B04" "L114A04" "G267A11" "L122B01" "L114B09" "S356A03" "LIM0312B02B" "E105C07" "W17A08" "G262C02" "E101F11" "G244A08" "G243B01" "L114B18" "E101F11" "L115B12" "LIM0302B01C" "LIM0312A06B" "LIM0301B04C" "L115B11" "E101B04" "G210B08" "L102B10" "R803L05" "L122B12" "L115B10" "LIM0302B04B" "LIM0312A06B" "L115B05" "LIM0314B05B" "S335A04" "E105A07" "L121B10" "L121B02" "L113B20" "L115A12" "L115A08" "LIM0313A03B" "S321B05" "S325B09" "S327B03" "S350A02" "S350A01" "S351A05" "S321B05" "S333A06" "ERI0112E02C" "LIM0314A05B" "W17A09" "L107B12" "S332A01" "S346A06" "LIM0312A05B")

# RSS feed output
output=$(curl --silent "$RSS_URL" | grep -E '(title>|description>)' | tail -n +4 | sed -e 's/^[ \t]*//' | sed -e 's/<title>//' -e 's/<\/title>//' -e 's/<description>/  /' -e 's/<\/description>//')

# Check if RSS feed contains any keywords
for keyword in "${KEYWORDS[@]}"; do
    if echo "$output" | grep -q "$keyword"; then
        echo "Take a look. Maintenance is happening in $keyword"
    fi
done
