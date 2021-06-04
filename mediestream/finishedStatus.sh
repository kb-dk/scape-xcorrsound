SCRIPT_DIR=$(dirname "$(readlink -f -- ${BASH_SOURCE[0]})")

echo "logfile,indexing Time,mp3 count,mp3 total size"
grep -l "Finished" "$SCRIPT_DIR/"*.log | while read -r file; do
    grep -q '^List consist of\s\+[0-9]\+' "$file" || continue;
    count=$(grep '^List consist of' "$file" | cut -d' ' -f4);
    duration=$(grep 'for list' "$file" | cut -d' ' -f8- | sed 's/maj/may/' |xargs -r -I'{2}' date -d'{2}' +%s | awk 'NR%2{printf "-%s+",$0;next;}1' | bc -q);
    mp3Size=$(cat "/data01/larm/mediestream-index/ismirInput/$(basename $file .log)" | tr '\n' '\0' | du -ch --files0-from=- | grep 'total'| cut -f1);
    echo "$(basename $file),$duration seconds,$count files,$mp3Size";
done