#!/bin/zsh

# Use first argument as file, if no argument is given use speed.csv
log_file=${1:=speed.csv}

result=$(speedtest-cli)

# Filter results
if echo $result | grep -q 'Selecting best server based on latency'
then
    latency=$(echo -e $result | sed -n "s/^.*km]: \(.*\) ms'/\1/p")
    download=$(echo -e $result | sed -n "s/^Download: \(.*\) Mbit\/s/\1/p")
    upload=$(echo -e $result | sed -n "s/^Upload: \(.*\) Mbit\/s/\1/p")
else
    latency='NO'
    download='INTER'
    upload='WOBBLES'
fi
# If the logfile does not exist, create it with a header
if [ ! -f $log_file ]
then
    echo "latency,download speed,upload speed" > $log_file
fi

# Write to file
echo "$(date -Iseconds),$latency,$download,$upload" >> $log_file


