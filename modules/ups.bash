#! /bin/bash
# Checks APC-UPS status

if ! which apcaccess &> /dev/null; then
    echo "apcaccess not installed"
    exit 1
fi

echo "******************** UPS status ********************"
apcaccess status | egrep -i "STATUS  |LOADPCT|LINEV  |BCHARGE|BATTV  |OUTPUTV"