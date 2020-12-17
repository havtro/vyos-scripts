#!/bin/bash
#arg1=dhcpPublicInterface, arg2=ping-internet-ip
tmpfile="/tmp/checkInternet"

pingInternet() {
# input src dst
echo "ping internet"
ping -c 3 -W 2 -I $1 $2 1>/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "check Failed"
  return 1
fi
}

ext_ip=$(bash -ic "show interfaces ethernet $1 brief | grep $1" |  awk '{print $2}' )
tries=$(cat "$tmpfile")

REGEX="^(192\.168|10\.|172\.1[6789]\.|172\.2[0-9]\.|172\.3[01]\.|169\.254\.)"
if [[ $ext_ip =~ $REGEX ]] || [[ "$ext_ip"x == "-x" ]]; then
  echo $ext_ip
  echo "private or non ip found"
  if [ "$tries" -gt "5" ]; then
    echo "$tries reached end, rebooting"
    reboot now
  else
      bash -ic "renew dhcp interface $1"
  fi
  tries=$(($tries + 1))
  echo $tries > $tmpfile
else
  echo "public ip found"
  pingInternet $1 $2
  if [ $? -ne 0 ]; then
    echo "Internet is down"
    bash -ic "renew dhcp interface $1"
    tries=$(($tries + 1))
    echo $tries > $tmpfile
  else
    echo "Internet is working"
    echo 0 > $tmpfile
  fi
fi
