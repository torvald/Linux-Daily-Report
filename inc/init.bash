#!/bin/bash
if (( $UID != 0 )); then
	echo "*!* Fatal: Must be run by root"
	exit 1
fi

export TEMP_DIR=/tmp/daiy_report_$$
mkdir $TEMP_DIR
if (( $? != 0 )); then
	echo "*!* Fatal: Error creating temp dir: $TEMP_DIR (/tmp/daily_report_$$)"
	exit 1
fi


export MAIL=$(tempfile -n $TEMP_DIR/daily_report_$$_MAIL)
if (( $? != 0 )); then
	echo "*!* Fatal: Error creating tempfile: $MAIL (daily_report_$$_MAIL)"
	exit 1
fi
export TEMP=$(tempfile -n $TEMP_DIR/daily_report_$$_TEMP)
if (( $? != 0 )); then
	echo "*!* Fatal: Error creating tempfile: $TEMP (daily_report_$$_TEMP)"
	exit 1
fi
export TEMP2=$(tempfile -n $TEMP_DIR/daily_report_$$_TEMP2)
if (( $? != 0 )); then
	echo "*!* Fatal: Error creating tempfile: $TEMP (daily_report_$$_TEMP2)"
	exit 1
fi

