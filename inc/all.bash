# COLARGOL version..
COLARGOL="Colargol VIII"

CHKROOTKIT="/usr/sbin/chkrootkit -q"
LSOF=/usr/bin/lsof
SENSORS=/usr/bin/sensors
VNSTAT="/usr/bin/vnstat -i eth0"

LOG_BASE=/home/staff/drift/manuelle_logger
EXCLUDES=/home/staff/drift/data/log_excludes

USED_REFS=/tmp/used_refs.data

MAILTO=$(config recivers)

DATE_YESTERDAY=$(date --date "1 day ago" +%d.%m.%Y)
TIME_STARTED=$(date +%H:%M:%S)

function out {

	echo -e "$@" >> $MAIL
}

out "*"
out "* COLARGOL RAPPORT FRA GÅRSDAGENS HENDELSER ($DATE_YESTERDAY)\n*"
out "* Rapport begynt $TIME_STARTED"
out "* Rapport ferdig TIME_FINISHED"
out "*"
out "* Dette skjedde $DATE_YESTERDAY\n*\n"


out "Trafikk:"
out "* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *"
out "\t\t$($VNSTAT -h -s | grep "rx" | cut -b 15-56)"
out "\t\t$($VNSTAT -h -s | grep "yesterday" | cut -b 15-58)\n"
out "$($VNSTAT -h | head -n13 | tail -n12)"
out "* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *\n"

CPUTEMP=$($SENSORS | grep -A 20 "ISA adapter" | grep 'temp[1,3]' | awk '{print $2}' | xargs)
out "Temperaturer:"
out "* * * * * * * * * * * * * * * * * * * * * * * *"
out "CPU0: $(echo $CPUTEMP | awk '{print $1}')"
out "MB  : $(echo $CPUTEMP | awk '{print $2}')"
out "* * * * * * * * * * * * * * * * * * * * * * * *\n"


out "fail2ban bans:"
out "* * * * * * * * * * * * * * * * * * * * * * * *"
grep "$(date --date="yesterday" +"%Y-%m-%d")" /var/log/fail2ban.log | grep "Ban" > $TEMP

while read LINE
do
	TIMESTAMP=$(echo "$LINE" | awk '{print $2}')
	TIMESTAMP=$(echo $TIMESTAMP | awk -F ',' '{print $1}')
	SOURCE=$(echo "$LINE" | awk '{print $7}')
	SERVICE=$(echo "$LINE" | awk '{print $5}')

	out "$TIMESTAMP: $SERVICE $SOURCE"

done < "$TEMP"
out "* * * * * * * * * * * * * * * * * * * * * * * *\n"


out "su akseptert:"
out "* * * * * * * * * * * * * * * * * * * * * * * *"
grep "$(date --date="yesterday" +"%b %_d")" /var/log/auth.log | grep "Successful su for" > $TEMP

while read LINE
do
	TIMESTAMP=$(echo "$LINE" | awk '{print $3}')
	TO_USER=$(echo "$LINE" | awk '{print $9}')
	FROM_USER=$(echo "$LINE" | awk '{print $11}')

	out "$TIMESTAMP: $FROM_USER -> $TO_USER"

done < "$TEMP"
out "* * * * * * * * * * * * * * * * * * * * * * * *\n"



out "su feilet:"
out "* * * * * * * * * * * * * * * * * * * * * * * *"
grep "$(date --date="yesterday" +"%b %_d")" /var/log/auth.log | grep "FAILED su for" > $TEMP

while read LINE
do
	TIMESTAMP=$(echo "$LINE" | awk '{print $3}')
	TO_USER=$(echo "$LINE" | awk '{print $9}')
	FROM_USER=$(echo "$LINE" | awk '{print $11}')

	out "$TIMESTAMP: $FROM_USER -> $TO_USER"


done < "$TEMP"
out "* * * * * * * * * * * * * * * * * * * * * * * *\n"

#
#out "ssh facepalm:"
#out "* * * * * * * * * * * * * * * * * * * * * * * *"
#grep "$(date --date="yesterday" +"%b %_d")" /var/log/auth.log | awk 'gsub(".*sshd.*Failed password for (invalid user )?", "") {print $1}' | sort | uniq -c | sort -rn | head -n6 > $TEMP
#awk 'gsub(".*sshd.*Failed password for (invalid user )?", "") {print $1}' /var/log/auth.log* | sort | uniq -c | sort -rn | head -n6 > $TEMP2
#
#out "-Yesterday-\t\t-AllTime-"
#x=2
#while (( $x != 7 )); do
#
#	ONE=$(head -n$x $TEMP | tail -n1)
#	ATT=$(echo "$ONE" | awk '{print $1}')
#	USER=$(echo "$ONE" | awk '{print $2}')
#
#	if (( ${#USER} > 6 )); then
#		ONE=$(echo "$USER:\t$ATT")
#	else
#		ONE=$(echo "$USER:\t\t$ATT")
#	fi
#
#	TWO=$(head -n$x $TEMP2 | tail -n1)
#	ATT=$(echo "$TWO" | awk '{print $1}')
#	USER=$(echo "$TWO" | awk '{print $2}')
#
#	if (( ${#USER} > 5 )); then
#		TWO=$(echo "$USER:\t$ATT")
#	else
#		TWO=$(echo "$USER:\t\t$ATT")
#	fi
#
#	out "$ONE\t $TWO"
#	x=$(($x+1))
#done
#
#
#grep "$(date --date="yesterday" +"%b %_d")" /var/log/auth.log | awk 'gsub(".*sshd.*Failed password for (invalid user )?", "") {print $3}' | sort | uniq -c | sort -rn | head -n6 > $TEMP
#awk 'gsub(".*sshd.*Failed password for (invalid user )?", "") {print $3}' /var/log/auth.log* | sort | uniq -c | sort -rn | head -n6 > $TEMP2
#
#out "\n-Yesterday-\t\t-AllTime-"
#x=2
#while (( $x != 7 )); do
#
#	ONE=$(head -n$x $TEMP | tail -n1)
#	ATT=$(echo "$ONE" | awk '{print $1}')
#	USER=$(echo "$ONE" | awk '{print $2}')
#
#	if (( ${#USER} > 6 )); then
#		ONE=$(echo "$USER\t$ATT")
#	else
#		ONE=$(echo "$USER\t\t$ATT")
#	fi
#
#	TWO=$(head -n$x $TEMP2 | tail -n1)
#	ATT=$(echo "$TWO" | awk '{print $1}')
#	USER=$(echo "$TWO" | awk '{print $2}')
#
#	if (( ${#USER} > 5 )); then
#		TWO=$(echo "$USER\t$ATT")
#	else
#		TWO=$(echo "$USER\t\t$ATT")
#	fi
#
#	out "$ONE\t $TWO"
#	x=$(($x+1))
#done
#out "* * * * * * * * * * * * * * * * * * * * * * * *\n"
#


out "Utgåtte brukere:"
out "* * * * * * * * * * * * * * * * * * * * * * * *"
grep "$(date --date="yesterday" +"%b %_d")" /var/log/auth.log | grep "(account expired)" > $TEMP

if [ ! -e $USED_REFS ]; then
	touch $USED_REFS
fi

while read LINE
do
	TIMESTAMP=$(echo "$LINE" | awk '{print $3}')
	USER=$(echo "$LINE" | awk '{print $8}')
	if ! grep -q $USER $USED_REFS ; then
	        echo $USER >> $USED_REFS
		out "$TIMESTAMP: $USER"
	fi

done < "$TEMP"
rm $USED_REFS
out "* * * * * * * * * * * * * * * * * * * * * * * *\n"


out "Antall NIC feil:"
out "* * * * * * * * * * * * * * * * * * * * * * * *"
zgrep "$(date --date="yesterday" +"%b %_d")" /var/log/syslog.2.gz |\
	grep "Transmit error, Tx status register 82" > $TEMP
grep "$(date --date="yesterday" +"%b %_d")" /var/log/syslog.1 |\
	grep "Transmit error, Tx status register 82" >> $TEMP
grep "$(date --date="yesterday" +"%b %_d")" /var/log/syslog |\
	grep "Transmit error, Tx status register 82" >> $TEMP
out "$(cat $TEMP | wc -l)"
out "* * * * * * * * * * * * * * * * * * * * * * * *\n"



out "Åpne porter:"
out "* * * * * * * * * * * * * * * * * * * * * * * *"

out "$(printf "%-6s %-10s %-6s %-8s\n" "Port" "Command" "PID" "User")"
out "$(printf "%-6s %-10s %-6s %-8s\n" "----" "-------" "---" "----")"

netstat -an | grep "LISTEN" | perl -ne 'print "$1\n" if /0\.0\.0\.0:(\d+)\s+0\.0\.0\.0:\*/ || /:::(\d+)\s+:::\*/' | sort -n | uniq > $TEMP

while read PORT
do
	/usr/bin/lsof -i :${PORT} | grep LISTEN | tail -n 1 | while read LINE
	do
		set $LINE
		COMMAND=$1
		PID=$2
		LSOF_USER=$3
		out "$(printf "%-6d %-10s %-6d %-8s\n" "$PORT" "$COMMAND" "$PID" "$LSOF_USER")"
	done
done < "$TEMP"
out "* * * * * * * * * * * * * * * * * * * * * * * *\n"


out "Mail:"
out "* * * * * * * * * * * * * * * * * * * * * * * *"
TOTAL_RECEIVED=$(grep "$(date --date="yesterday" +"%b %_d")" /var/log/mail.log | grep "postfix/pickup" | grep "uid=500" | wc -l)
TOTAL_SENT=0
grep "$(date --date="yesterday" +"%b %_d")" /var/log/mail.log | grep "postfix/pickup" | grep -v "uid=500" > $TEMP
while read LINE
do
	set $LINE
	USER=${8:6}
	USER=${USER%?}

	echo "$USER" >> $TEMP2

	TOTAL_SENT=$(($TOTAL_SENT+1))

done < "$TEMP"

cat $TEMP2 | awk '{ total[$1] += 1 } END { for (i in total) print total[i], i}' | sort -nr | head -n5 > $TEMP

out "Total sent: \t$TOTAL_SENT"
out "Total received: $TOTAL_RECEIVED\n"
X=1
out "Top senders:"
while read LINE
do
	set $LINE
	out "$X. $2\t$1 \t($((100 * $1 / $TOTAL_SENT ))%)"
	X=$(($X+1))
done < "$TEMP"
out "* * * * * * * * * * * * * * * * * * * * * * * *\n"



out "MySQL:"
out "* * * * * * * * * * * * * * * * * * * * * * * *"
TOTAL=$(du -ms /home/data/mysql | awk '{print $1}')
du -ms /home/data/mysql/* | sort -nr | head -n10 > $TEMP

out "Total size: $TOTAL MB\n"
X=1
while read LINE
do

#	set $LINE
#	SIZE=$1
#	USER=$2
#	USER=$(echo "$2" | awk -F '/' '{print $4}')

#	out "$X. $USER:\t${SIZE} MB\t ($((100*$SIZE/TOTAL))%)"
#	X=$(($X+1))


set $LINE
        SIZE=$1
        USER=$2
        USER=$(echo "$2" | awk -F '/' '{print $5}')

        out "$X. $USER:\t\t${SIZE} MB\t ($((100*$SIZE/TOTAL))%)"
        X=$(($X+1))

done < "$TEMP"
out "* * * * * * * * * * * * * * * * * * * * * * * *\n"


#out "chkrootkit:"
#out "* * * * * * * * * * * * * * * * * * * * * * * * *"
#$CHKROOTKIT -q > $TEMP
#LINES=$(cat $TEMP | wc -l)
#cat $TEMP | head -n1 >> $MAIL
#cat $TEMP | tail -n$((LINES-1)) | awk '{ for (i=1;i<=NF;i++) print $i }' | sort >> $MAIL
#out "* * * * * * * * * * * * * * * * * * * * * * * * *\n"


out "Prosesses running on users:"
out "* * * * * * * * * * * * * * * * * * * * * * * * *"
out "$(ps -ef | awk '{print $1}' | sort | uniq -c | sort -rn | head)"
out "* * * * * * * * * * * * * * * * * * * * * * * * *\n"

out "Files open by users:"
out "* * * * * * * * * * * * * * * * * * * * * * * * *"
out "$(lsof | awk '{print $3}' | sort | uniq -c | sort -rn | head)"
out "* * * * * * * * * * * * * * * * * * * * * * * * *\n"



grep "$(date --date="yesterday" +"%b %_d")" /var/log/auth.log | grep -v -f $EXCLUDES/auth | grep -v "COMMAND=bin/status_check.bash" >> $TEMP_DIR/auth.log.txt

#zgrep "$(date --date="yesterday" +"%b %_d")" /var/log/syslog.2.gz | grep -v -f $EXCLUDES/syslog >> $TEMP_DIR/syslog.txt
#grep "$(date --date="yesterday" +"%b %_d")" /var/log/syslog.1 | grep -v -f $EXCLUDES/syslog >> $TEMP_DIR/syslog.txt
#grep "$(date --date="yesterday" +"%b %_d")" /var/log/syslog | grep -v -f $EXCLUDES/syslog >> $TEMP_DIR/syslog.txt

grep "$(date --date="yesterday" +"%b %_d")" /var/log/messages | grep -v -f $EXCLUDES/messages >> $TEMP_DIR/messages.txt

grep "$(date --date="yesterday" +"%b %d")" /var/log/apache2/error.log | grep -v -f $EXCLUDES/apache >> $TEMP_DIR/apache_error.log.txt

grep "$(date --date="yesterday" +"%Y-%m-%d")" /var/log/fail2ban.log | grep -v -f $EXCLUDES/fail2ban >> $TEMP_DIR/fail2ban.log.txt

grep "$(date --date="yesterday" +"%b %_d")" /var/log/mail.err | grep -v -f $EXCLUDES/mail >> $TEMP_DIR/mail.err.txt


out "Attachments:"
out "* * * * * * * * * * * * * * * * * * * * * * * *"
ATTACHMENTS=""
for FILE in auth.log.txt apache_error.log.txt messages.txt fail2ban.log.txt mail.err.txt syslog.txt
do
	if [ -f $TEMP_DIR/$FILE ]; then

		SIZE=$(du -b $TEMP_DIR/$FILE | awk '{print $1}')
		if (( $SIZE == 0 )); then
			out "- $FILE is 0 bytes. Skipping"
		else
			ATTACHMENTS="$ATTACHMENTS $TEMP_DIR/$FILE"
		fi
	else
		out "- $FILE is missing. Not parsed?"
	fi

done
out "* * * * * * * * * * * * * * * * * * * * * * * *\n"

TIME_FINISHED=$(date +%H:%M:%S)
sed -i "s/TIME_FINISHED/$TIME_FINISHED/g" $MAIL

out "\nRapport slutt\n--\n$COLARGOL"

cat $MAIL | mutt -s "Daglig rapport fra Colargol" -a $ATTACHMENTS -- $MAILTO
if [ -d $TEMP_DIR ]; then
	rm -rf $TEMP_DIR
fi
