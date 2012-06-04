#!/bin/bash

# Creds til drift@TIHLDE - mye snaxx hentet fra dem

source inc/functions.bash
source inc/init.bash

errorMsg=""

MODULES=$(config modules)
if [[ $MODULES == "" ]]; then
    MODULES="general" # Add all
fi
for MODUL in $MODULES; do
    if [ ! -f modules/$MODUL ]; then
        errorMsg=$errorMsg"<br> Module $MODUL does not exist!<br>"    
        continue
    fi
    modules/$MODUL > $TEMP # temp file from systemCheck
    if [ $? == 0 ]; then
        cat $TEMP | sed 's/$/<br>/g' | sed 's/\t/\&emsp;/g' >> $MAIL
        echo "<br><br>" >> $MAIL
    else
        errorMsg=$errorMsg"<br> Module $MODUL returned with error signal<br>"
    fi
done

# appending any errors
if [[ $errorMsg != "" ]]; then
    sed -i "1i$errorMsg" $MAIL
fi

if [[ $1 == "test" ]]; then
    cat $MAIL
else 
    RECIVERS=$(config recivers)
    for RECIVER in $RECIVERS; do
        cat $MAIL | mail -a 'Content-Type: text/html' -s "Dailyreport test" $RECIVER
    done
fi


# Cleaning
rm -r $TEMP_DIR
