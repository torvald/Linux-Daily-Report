#! /bin/bash
# General system info, memory, load etc.

echo "******************** general system status ********************"
mem=$(free -m | grep "Mem" | awk '{print $3,"/",$2," MB (FREE:",$4,"MB)"}')
swap=$(free -m | grep "Swap" | awk '{print $3,"/",$2}')
load=$(uptime | awk '{print $10, $11, $12}')
uptime=$(uptime | awk '{print $3, $4}' | tr -d ",")

echo UPTIME: $uptime
echo SYSTEMLOAD: $load
echo MEMORY: $mem
echo SWAP  : $swap
