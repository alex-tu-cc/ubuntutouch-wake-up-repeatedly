#!/bin/dash
#Because of device suspend will interfere with the sleep time of user process.
#So the strategy of this script is to wake up device every $WAKE_PERIOD.
#And let this script to check the passed time every 6 mins.
#So the max time shift of issuing power button event is $WAKE_PERIOD + 6 minutes.
# !!!!! Not complete, pending currently.

counter=0
START_TIME=`date +%s`
PASSED_TIME=0
# get random seconds from 10 ~ 1800
#RANG=$PWR_KEY_TIME_RANGE
RANG=180
FLOOR=10
sleep_secs=10
RANDOM='od -vAn -N2 -i /dev/urandom'
get_random_secs() {
   # local __resultvar=$1
    #echo $RANDOM
    local myresult=$((`$RANDOM` % $RANG))
    #echo $myresult
    #echo $RANG
    while [ "$myresult" -le $FLOOR ]
    do
        myresult=$((`$RANDOM` % $RANG))
        #myresult=`od -vAn -N2 -i /dev/urandom`
        myresult=$(($myresult % $RANG))
    done
    echo "$myresult"
#    if [[ "$__resultvar" ]]; then
#        eval $__resultvar="'$myresult'"
#    else
#        echo "$myresult"
#    fi  

}
rm /home/test.log

while [ 1 ] 
do
    counter=$(($counter+1))
    #let "counter += 1"
 #   logger "counter = $counter, sleep_secs=$sleep_secs"
    #let "sleep_secs=$(get_random_secs)"
    #sleep_secs=$(($(get_random_secs)))
    sleep_secs=$(get_random_secs)

    # Alex test
    sleep_secs=720

 #   logger "sleep $sleep_secs"
    #let "PASSED_TIME = `date +%s` - $START_TIME"
    PASSED_TIME=$((`date +%s` - $START_TIME))
#   logger "$PASSED_TIME seconds passed ..."
    logger $0 "$counter times: $PASSED_TIME seconds passed, will sleep $sleep_secs seconds."
    echo "`date` $counter times: $PASSED_TIME seconds passed, will sleep $sleep_secs seconds." >> /home/test.log


    powerd-cli wakeup $sleep_secs
    /usr/bin/press_pwr_key.o
    sleep $sleep_secs
    #sleep 2
done

