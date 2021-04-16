

Started this job in a screen

```bash
#Clean temp files
rm -rf /dev/shm/*

#Clean existing indexes
rm /data01/larm/dr-dat-index/P3/dr-dat.P3.01.??.list.index*

#Generate new indexes for each month of 01
echo -e "01\n02\n03\n04\n05\n06\n07\n08\n09\n10\n11\n12" | 
xargs -r -i -P12 ./runIsmirIndex.sh P3 dr-dat.P3.01.{}.list;

```

Also did

```bash

rm /data01/larm/dr-dat-index/P3/dr-dat.P3.91.01.list.index*
./runIsmirIndex.sh P3 dr-dat.P3.91.01.list;
```

All this came from the indexes starting very late

First line of each
```
18693482 /dr-dat/3/files/Batch24/Disc09/mp3_128kbps/P3_0200_0400_010207_001.mp3
63508202 /dr-dat/3/files/Batch24/Disc09/mp3_128kbps/P3_1400_1600_010331_001.mp3
95981825 /dr-dat/3/files/Batch24/Disc03/mp3_128kbps/P3_1400_1600_010518_001.mp3
129094003 /dr-dat/3/files/Batch24/Disc03/mp3_128kbps/P3_1400_1600_011012_001.mp3
131022960 /dr-dat/2/files/Batch17/Disc11/mp3_128kbps/P3_1400_1600_010921_001.mp3
132984940 /dr-dat/3/files/Batch24/Disc03/mp3_128kbps/P3_0400_0600_010803_001.mp3
167737062 /dr-dat/3/files/Batch24/Disc09/mp3_128kbps/P3_1600_1800_010406_001.mp3
178292787 /dr-dat/4/files/Dat-samling/md5 filer uden mp3/Foundfiles/P3_2200_0000_910114_001.mp3
```

This will cause matches such as

```
match in '/dr-dat/3/files/Batch24/Disc03/mp3_128kbps/P3_2000_2200_010703_001.mp3' at 220:42:20 with distance 1528
match in '/dr-dat/3/files/Batch24/Disc03/mp3_128kbps/P3_2000_2200_010703_001.mp3' at 220:43:12 with distance 2833
match in '/dr-dat/3/files/Batch24/Disc03/mp3_128kbps/P3_2000_2200_010703_001.mp3' at 220:43:14 with distance 2833
match in '/dr-dat/3/files/Batch24/Disc03/mp3_128kbps/P3_2000_2200_010703_001.mp3' at 270:14:53 with distance 1578
match in '/dr-dat/3/files/Batch24/Disc03/mp3_128kbps/P3_2000_2200_010703_001.mp3' at 272:59:07 with distance 1515
match in '/dr-dat/3/files/Batch24/Disc03/mp3_128kbps/P3_2000_2200_010703_001.mp3' at 272:59:59 with distance 2781
match in '/dr-dat/3/files/Batch24/Disc03/mp3_128kbps/P3_2000_2200_010703_001.mp3' at 273:00:01 with distance 2781
```

Which are non-sensitial values



Running

```bash
for file in $(ls /data01/larm/dr-dat-index/P?/dr-dat.P?.??.??.list.index); do
echo -n -e "$file\t"
cat $file.map | cut -d' ' -f1 | xargs -r -i echo "({}*400)/$(stat --printf="%s" $file)" | bc | sort -u -n | wc -l
done | grep -v "101$"
```
This command basically checks if any index have a single file that takes up more than 1% of that index. If so, this would indicate something very wrong.

It resulted in

```
/data01/larm/dr-dat-index/P2/dr-dat.P2.89.06.list.index	97
/data01/larm/dr-dat-index/P2/dr-dat.P2.89.07.list.index	88
/data01/larm/dr-dat-index/P2/dr-dat.P2.90.02.list.index	99
/data01/larm/dr-dat-index/P3/dr-dat.P3.01.01.list.index	34
/data01/larm/dr-dat-index/P3/dr-dat.P3.01.02.list.index	34
/data01/larm/dr-dat-index/P3/dr-dat.P3.01.03.list.index	35
/data01/larm/dr-dat-index/P3/dr-dat.P3.01.04.list.index	35
/data01/larm/dr-dat-index/P3/dr-dat.P3.01.05.list.index	35
/data01/larm/dr-dat-index/P3/dr-dat.P3.01.06.list.index	34
/data01/larm/dr-dat-index/P3/dr-dat.P3.01.07.list.index	34
/data01/larm/dr-dat-index/P3/dr-dat.P3.01.08.list.index	34
/data01/larm/dr-dat-index/P3/dr-dat.P3.01.09.list.index	35
/data01/larm/dr-dat-index/P3/dr-dat.P3.01.10.list.index	34
/data01/larm/dr-dat-index/P3/dr-dat.P3.01.11.list.index	34
/data01/larm/dr-dat-index/P3/dr-dat.P3.01.12.list.index	34
/data01/larm/dr-dat-index/P3/dr-dat.P3.91.01.list.index	29
/data01/larm/dr-dat-index/P4/dr-dat.P4.02.05.list.index	89
/data01/larm/dr-dat-index/P4/dr-dat.P4.97.01.list.index	7
/data01/larm/dr-dat-index/P4/dr-dat.P4.97.02.list.index	8
/data01/larm/dr-dat-index/P4/dr-dat.P4.97.03.list.index	16
/data01/larm/dr-dat-index/P4/dr-dat.P4.97.04.list.index	6
/data01/larm/dr-dat-index/P4/dr-dat.P4.97.05.list.index	7
/data01/larm/dr-dat-index/P4/dr-dat.P4.97.09.list.index	2
/data01/larm/dr-dat-index/P4/dr-dat.P4.99.03.list.index	1
```

We can immediately discard the P3.01 entries (as well as P3.91 for the same reason), as these are still being created.
This leaves us with
```
/data01/larm/dr-dat-index/P2/dr-dat.P2.89.06.list.index	97
/data01/larm/dr-dat-index/P2/dr-dat.P2.89.07.list.index	88
/data01/larm/dr-dat-index/P2/dr-dat.P2.90.02.list.index	99
/data01/larm/dr-dat-index/P4/dr-dat.P4.02.05.list.index	89
/data01/larm/dr-dat-index/P4/dr-dat.P4.97.01.list.index	7
/data01/larm/dr-dat-index/P4/dr-dat.P4.97.02.list.index	8
/data01/larm/dr-dat-index/P4/dr-dat.P4.97.03.list.index	16
/data01/larm/dr-dat-index/P4/dr-dat.P4.97.04.list.index	6
/data01/larm/dr-dat-index/P4/dr-dat.P4.97.05.list.index	7
/data01/larm/dr-dat-index/P4/dr-dat.P4.97.09.list.index	2
/data01/larm/dr-dat-index/P4/dr-dat.P4.99.03.list.index	1
```

This is okay if they all match the number of files in their filelists

```bash
wc -l /data01/larm/dr-dat-index/filelists/P2/dr-dat.P2.89.06.list
wc -l /data01/larm/dr-dat-index/filelists/P2/dr-dat.P2.89.07.list
wc -l /data01/larm/dr-dat-index/filelists/P2/dr-dat.P2.90.02.list
wc -l /data01/larm/dr-dat-index/filelists/P4/dr-dat.P4.02.05.list
wc -l /data01/larm/dr-dat-index/filelists/P4/dr-dat.P4.97.01.list
wc -l /data01/larm/dr-dat-index/filelists/P4/dr-dat.P4.97.02.list
wc -l /data01/larm/dr-dat-index/filelists/P4/dr-dat.P4.97.03.list
wc -l /data01/larm/dr-dat-index/filelists/P4/dr-dat.P4.97.04.list
wc -l /data01/larm/dr-dat-index/filelists/P4/dr-dat.P4.97.05.list
wc -l /data01/larm/dr-dat-index/filelists/P4/dr-dat.P4.97.09.list
wc -l /data01/larm/dr-dat-index/filelists/P4/dr-dat.P4.99.03.list
```
And all the counts match.