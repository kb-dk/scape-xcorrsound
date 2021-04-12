#!/usr/bin/env bash

outputfile="$1"

klipLinker="http://miaplacidus.statsbiblioteket.dk:9311/drdat/"


[ -z "${outputile+x}" ] && echo "path,file,offset,channel,hitStart,distance,playbackUrl" > "$outputfile"

while read line; do
  [ "$outputfile" != "/dev/stdout" ] && echo "$line";
  if [ -z "${outputile+x}" ]; then
    #match in '/dr-dat/4/files/Batch33/Disc13/mp3_128kbps/P3_2200_0000_041202_001.mp3' at 00:01:35 with distance 1207
    echo "$line" | grep -E -q "^match in '\S+' at \S+ with distance [0-9]+$" - || continue

    path=$(echo "$line" | cut -d' ' -f3 | cut -d\' -f2)
    file=$(echo "$path" | rev | cut -d'/' -f1 | rev)
    offset=$(echo "$line" | cut -d' ' -f5)

    distance=$(echo "$line" | cut -d' ' -f8)
    channel=$(echo "$file" | cut -d'_' -f1)
    date=$(echo "$file" | cut -d'_' -f4)
    fileStart=$(echo "$file" | cut -d'_' -f2)

    fileStartSeconds=$(date --date="$date $fileStart" +%s)
    hitStartSeconds=$(echo "$fileStartSeconds" + "$(date -d $offset +%s) - $(date -d 'today 00:00:00' +%s)" | bc)
    hitStart=$(date -d "@${hitStartSeconds}" "+%Y-%m-%d %H:%M:%S")

    #"http://teg-desktop.sb.statsbiblioteket.dk:8080/drdat/?time=1991-01-01+16:33:11&channel=P1"
    echo "$path,$file,$offset,$channel,$hitStart,$distance,${klipLinker}?time=${hitStart// /+}&channel=$channel" >> "$outputfile"
  fi
done
