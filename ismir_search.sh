#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$(readlink -f -- ${BASH_SOURCE[0]})")

SCRIPT=$(basename "$(readlink -f -- ${BASH_SOURCE[0]})")

#set -x


ISMIR_CONCURRENT_SEARCH=${ISMIR_CONCURRENT_SEARCH:-12}

#TODO explain the parameters here
function usage(){
  echo "Usage: $SCRIPT NEEDLE.MP3 CHANNEL YEAR  MONTH..."
  echo "NEEDLE.MP3 is the mp3 file you are searching for (in the haystack)"
  echo "CHANNEL must be one of P1, P2, P3, P4"
  echo "YEAR must be the year, as two digits. Like 99 or 04"
  echo "MONTH is repeateable. It is the 2-digit month-number, like 02 or 11"
  echo ""
  echo "Search for sample.mp3 in P3 in july 2004 and for the rest of the year: "
  echo -e "\t$SCRIPT sample.mp3 P3 04  07 08 09 10 11 12"
}


export needle="$1"
shift
if [ "$needle" == "" ]; then
  usage
  exit 1
fi
if [ "$needle" == "-h" ]; then
  usage
  exit 0
fi

export channel="$1"
shift
if [[ ! $channel =~ ^P[1-4]$ ]]; then
  usage
  exit 1
fi

export year=$1
shift
if [[ ! $year =~ ^[0-9]{2}$ ]]; then
  usage
  exit 1
fi


indexes=""
while [ "$1" != "" ]; do
  month=$1
  if [[ ! $month =~ ^[0-9]{2}$ ]]; then
    usage
    exit 1
  fi
  indexes="$indexes\n$month"
  shift
done

#This should ensure that the results are sorted
echo -e "$indexes" | xargs -r -i -P"$ISMIR_CONCURRENT_SEARCH" bash -c 'mkdir -p /dev/shm/$channel-$year-{}; export TmpSoundIndex=/dev/shm/$channel-$year-{}/; ismir_query -q "$needle" -d "/data01/larm/dr-dat-index/$channel/dr-dat.P3.$year.{}.list.index"' |\
  sed 's/mp3_128kbps/mp3-128kbps/' |\
 sort -t '_' -k4n -k2n |\
 sed 's/mp3-128kbps/mp3_128kbps/'

# match in '/dr-dat/4/files/Batch33/Disc13/mp3_128kbps/P3_2200_0000_041202_001.mp3' at 00:01:35 with distance 1207
