#! /bin/bash
# Check status of software raid on machine, does not include software raid partitions as md0p1

# Include software raid partitions? (true/false)
INCLUDEPARTS=false

if (($UID != 0)); then
    echo "*!* FATAL: RUN AS ROOT"
    exit 1
fi
echo "******************** mdadm arrays ********************"

if $INCLUDEPARTS; then
    grepLine="md([0-9])*"
else
    grepLine="md([0-9])*$"
fi

for array in `ls -1 /dev | egrep $grepLine`; do
    echo -ne "\E[35;40m\033[1mARRAY: \033[0m"
    echo -e "\E[35;40m\033[1m$array\033[0m"
    RAID_STATE=$(mdadm --detail /dev/$array | grep "State " | awk '{print "Raid state: "$3}')
    RAID_DISKS=$(mdadm --detail /dev/$array | grep -E '(Raid|Working) Devices' | xargs | awk '{print "RAID disks:",$8,"/",$4,"online"}')
    echo "$RAID_STATE"
    echo -e "$RAID_DISKS\n"
done