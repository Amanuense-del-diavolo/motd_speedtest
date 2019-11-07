#!/bin/bash

RESULT[1]="Ping: 0.0006 ms"
RESULT[2]="Download: 1913.98 Mbit/s"
RESULT[3]="Upload: 1190.96 Mbit/s"
 
green () {
  value=$(echo $1 | sed 's|\(.*\)\s[A-z].*|\1|' )
  unit=$(echo $2 | sed 's|.*\s\([A-z].*\)|\1|' )
  echo -e "\u001b[32m $value \u001b[0m $unit"
}

yellow () {
  value=$(echo $1 | sed 's|\(.*\)\s[A-z].*|\1|' )
  unit=$(echo $2 | sed 's|.*\s\([A-z].*\)|\1|' )
  echo -e "\u001b[33m $value \u001b[0m $unit" 
}

red () {
  value=$(echo $1 | sed 's|\(.*\)\s[A-z].*|\1|' )
  unit=$(echo $2 | sed 's|.*\s\([A-z].*\)|\1|' )
  echo -e "\u001b[31m $value \u001b[0m $unit" 
}

RESULT=$( speedtest-cli --simple )

download_tot=$(echo $RESULT | sed 's|.*Download:\s\(.*\)\sU.*|\1|' )
upload_tot=$(echo $RESULT | sed 's|.*Upload:\s\(.*\)|\1|' )
ping_tot=$(echo $RESULT | sed 's|Ping:\s\(.*\)\sD.*|\1|' )

download=$(echo $RESULT | sed 's|.*Download:\s\([0-9]\{1,\}\).*|\1|' )
upload=$(echo $RESULT | sed 's|.*Upload:\s\([0-9]\{1,\}\).*|\1|' )
ping=$(echo $RESULT | sed 's|Ping:\s\([0-9]\{1,\}\).*|\1|' )

u_download=$( echo $download_tot | sed 's|.*\s\([A-z]\).*|\1|')
u_upload=$( echo $upload_tot | sed 's|.*\s\([A-z]\).*|\1|')

if [ $u_download == "k" ]
then
  dwn=$( red $download_tot )
else
  if [ $download -ge "30" ]
  then
    dwn=$( green $download_tot )
  else
    if [ $download -ge "10" ]
    then
      dwn=$( yellow $download_tot )
    else
      dwn=$( red $download_tot )
    fi
  fi
fi


if [ $u_upload == "k" ]
then
  upl=$( red $upload_tot )
else
  if [ $upload -ge 8 ]
  then
    upl=$( green $upload_tot )
  else
    if [ $upload -ge 3 ]
    then
      upl=$( yellow $upload_tot )
    else
      upl=$( red $upload_tot )
    fi
  fi
fi


if [ $ping -le 20 ]
then
  png=$( green $ping_tot )
else
  if [ $ping -le 30 ]
  then
    png=$( yellow $ping_tot )
  else
    png=$( red $ping_tot )
  fi
fi


dwn=$( echo $dwn | sed 's|\(.*\)|Download\: \1|' )
upl=$( echo $upl | sed 's|\(.*\)|Upload\: \1|' )
png=$( echo $png | sed 's|\(.*\)|Ping\: \1|' )



num_dwn=${#dwn}
num_upl=${#upl}
num_png=${#png}

printf -v spc %10s

while [ $num_upl -lt $num_dwn ]
do
#  upl=$(echo $upl | sed 's|\(Upload\:\)\(\s.*\)|\1&\n${spc}\2|')
  upl=$(echo $upl | sed 's|\(Upload\:\)\(\s*\)|\1|')
#  echo $upl 1
  upl=$(echo $upl | sed 's|\(Upload\:\)\(\s.*\)|\2|')
 # echo $upl 2
  num_upl=$[$num_upl + 1]
done

while [ $num_png -le $num_dwn ]
do
	png=$(echo $png | sed 's|\(\Ping:\)\(.*\)|\1\d032\2|')
  num_png=$[$num_png + 1]
done

echo -e "\u001b[31m  _____             _             \u001b[33m  _  ___             "
echo -e "\u001b[31m |  __ \           | |            \u001b[33m | |/ (_)            "
echo -e "\u001b[31m | |__) |___  _   _| |_ ___ _ __  \u001b[33m | ' / _ _ __   __ _ "
echo -e "\u001b[31m |  _  // _ \| | | | __/ _ \ '__| \u001b[33m |  < | | '_ \ / _\` |"
echo -e "\u001b[31m | | \ \ (_) | |_| | ||  __/ |    \u001b[33m | . \| | | | | (_| |"
echo -e "\u001b[31m |_|  \_\___/\_____|_|\___/|_|    \u001b[33m |_|\_\_|_| |_|\__, |"
echo -e "\u001b[31m                                  \u001b[33m               __/ /"
echo -e "\u001b[31m                                  \u001b[33m              |___/"
echo -e "\u001b[0m"
echo -e $dwn
echo -e $upl
echo -e $png

