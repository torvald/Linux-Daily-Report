#! /bin/bash
# Checks system temperatures, greps may have to be changed per server, as they tend to be different

if ! which sensors &> /dev/null; then
    echo "lm-sensors not installed"
    exit 1
fi

echo "******************** system temperatures ********************"

cputemp=$(sensors | grep "CPU Temp" | awk '{print $3}')
mbtemp=$(sensors | grep "MB Temperature" | awk '{print $3}')
cpufan=$(sensors | grep "CPU Fan Speed" | awk '{print $4, $5}')

echo "CPU Temp: " $cputemp
echo "M/B Temp: " $mbtemp
echo "CPU Fan: " $cpufan
