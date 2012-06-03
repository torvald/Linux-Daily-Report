
function config() {
    FILE="dailyreport.conf"

    KEY=$1
    VALUE=$(egrep ^$KEY= $FILE | cut -d'=' -f2)
    if [ "$VALUE" = "" ]; then
        echo "$KEY not found in $FILE"
        exit 1
    else
        echo $VALUE
        exit 0
    fi
}


function out {
	echo -e "$@" >> $MAIL
}
