#!/bin/bash
# Author: José Manuel Motto
# rebuild using another watchdog scripts found on the internet (thanks!!)

# Services to check
SERVICES=('SERVICENAME')

# Contact email
EMAIL="youremail@domain.com"

# Hostname (automatic)
HOST=$HOSTNAME

# Subject
STATUS="Service-Status {$HOSTNAME}"

# Scrip init
for SERVICE in "${SERVICES[@]}"; do

        var=`ps -Af | grep -v grep | grep ${SERVICE} | awk '{ print $2 }'`
        echo "1) ${SERVICE} has a PID of -> $var "
        if [ -z "${var}" ]; then
                systemctl restart ${SERVICE}
                var=`ps -Af | grep -v grep | grep ${SERVICE} | awk '{ print $2 }'`
                echo "2) ${SERVICE} has a PID of  -> $var "
                
                if [ -z "${var}" ]; then
                       echo "${HOST}: ${SERVICE} can't be restarted!"  | mail -s "$STATUS" $EMAIL
                else
                       echo "${HOST}: ${SERVICE} has been restarted OK."  | mail -s "$STATUS" $EMAIL
                fi
        else
                echo "${SERVICE} is already ACTIVE."
        fi

done
