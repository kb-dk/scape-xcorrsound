#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$(readlink -f -- ${BASH_SOURCE[0]})")

SCRIPT=$(basename "$(readlink -f -- ${BASH_SOURCE[0]})")

source /opt/ffmpeg43/enable


ISMIR_CRITERIA=""
sound-match -v | grep -q -F "2.1.0" && ISMIR_CRITERIA=-c${DISTANCE:-2867}
export ISMIR_CRITERIA

ISMIR_CONCURRENT_SEARCH=${ISMIR_CONCURRENT_SEARCH:-12}

#TODO explain the parameters here
function usage() {
  echo "Usage: $SCRIPT NEEDLE.MP3 CHANNEL YEAR..."
  echo "NEEDLE.MP3 is the mp3 file you are searching for (in the haystack)"
  echo "CHANNEL must be one of P1, P2, P3, P4"
  echo "YEAR must be the year, as two digits. Like 99 or 04"
  echo ""
  echo "Search for sample.mp3 in P3 in 2004 and 2005"
  echo -e "\t$SCRIPT sample.mp3 P3 04 05"
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

years=""
while [ "$1" != "" ]; do
  year="$1"
  if [[ ! $year =~ ^[0-9]{2}$ ]]; then
    usage
    exit 1
  fi
  years="$years $year"
  shift
done

months="01 02 03 04 05 06 07 08 09 10 11 12"

#These for loops produce the cross product of years and the 12 months
for year in $years; do
  for month in $months; do
    echo "${year}.${month}"
  done
done |
xargs -r -i -P"$ISMIR_CONCURRENT_SEARCH" bash -c 'mkdir -p /dev/shm/$channel-{}; export TmpSoundIndex=/dev/shm/$channel-{}/; ismir_query $ISMIR_CRITERIA -q "$needle" -d "/data01/larm/dr-dat-index/$channel/dr-dat.$channel.{}.list.index"' |
    sed 's/mp3_128kbps/mp3-128kbps/' |
    sort -t '_' -k4n -k2n |
    sed 's/mp3-128kbps/mp3_128kbps/' |
./ismir_result_format.sh /dev/stdout

# match in '/dr-dat/4/files/Batch33/Disc13/mp3_128kbps/P3_2200_0000_041202_001.mp3' at 00:01:35 with distance 1207
