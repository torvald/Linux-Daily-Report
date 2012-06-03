#! /bin/bash
# Check smartdata of disks on system

if (($UID != 0)); then
    echo "*!* FATAL: RUN AS ROOT"
    exit 1
fi

ddtemp="/tmp/smartdata_$$"
touch $ddtemp

if [ -f $ddtemp ]; then
	ls -1 /dev | grep sd | cut -c 1-3 | uniq > $ddtemp
fi

echo "******************** DISK SMART DATA ********************"

while read DISK; do
    temp=$(smartctl -A /dev/$DISK | grep -i temperature | awk '{print $10}')
    smart=$(smartctl -a /dev/$DISK | grep "SMART overall-health self-assessment test result:" | cut -c 51-56)
    age=$(smartctl -A /dev/$DISK | grep Power_On_Hours | awk '{print $10}')
    loadcount=$(smartctl -A /dev/$DISK | grep "Load_Cycle_Count" | awk '{print $10}')
    size=$(smartctl -i /dev/$DISK | grep "Capacity" | awk '{print $3}' | sed 's/,//g')
    let size=$size/1000000000
    let ctemp=$temp
    let age=($age)/24
    let lcc=$loadcount

    output=""
    typeset -u UCDISK=$DISK

    if (( $ctemp > 42 && $ctemp < 48 )); then
        output+="$UCDISK: \E[33;40m\033[1m$temp"°C"\033[0m, "
    elif (( $ctemp > 48 )); then
        output+="$UCDISK: \E[31;40m\033[1m$temp"°C"\033[0m, "
    else
        output+="$UCDISK: \E[32;40m\033[1m$temp"°C"\033[0m, "
    fi

    if (( smart == "PASSED" )); then
        output+="SMART: \E[32;40m\033[1m$smart\033[0m. "
    else
        output+="SMART: \E[33;40m\033[1m$smart\033[0m. "
    fi

    if (( $age > 365 )); then
        age=$(echo "scale=2; $age"/365 | bc)
        output+="AGE: $age YEARS. "
    else
        output+="AGE: $age DAYS. "
    fi

    if (( lcc > 300000 )); then
        output+="LOAD COUNT: \E[31;40m\033[1m$loadcount\033[0m "
    elif (( lcc > 20000 && lcc < 300000 ));then
        output+="LOAD COUNT: \E[33;40m\033[1m$loadcount\033[0m "
    else
        output+="LOAD COUNT: \E[32;40m\033[1m$loadcount\033[0m "
    fi
    output+="SIZE: $size GB"
    echo -e $output

done < $ddtemp
rm $ddtemp
