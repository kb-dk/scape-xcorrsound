SCRIPT_DIR=$(dirname "$(readlink -f -- ${BASH_SOURCE[0]})")
source "$SCRIPT_DIR/setenv.sh"


echo -e "logfile\t indexing Time(seconds)\t mp3 count\t mp3 size(megabytes)\t index size(megabytes)"
grep -l "Finished" "$SCRIPT_DIR/"*.log | while read -r file; do
    grep -q '^List consist of\s\+[0-9]\+' "$file" || continue;

    count=$(grep '^List consist of' "$file" | \
            cut -d' ' -f4);

    duration=$(grep 'for list' "$file" | \
               cut -d' ' -f8- | \
               sed 's/maj/may/' | \
               xargs -r -I'{2}' date -d'{2}' +%s | \
               awk 'NR%2{printf "-%s+",$0;next;}1' | \
               bc -q);

    # shellcheck disable=SC2154
    mp3Size=$(cat "$baseFolder/ismirInput/$(basename "$file" .log)" | \
              tr '\n' '\0' | \
              du -chm --files0-from=- | \
              grep 'total' | \
              cut -f1);

    indexSize=$(du -chm "$baseFolder/index/$(basename "$file" .log).index" | \
                grep 'total' | \
                cut -f1);

    echo -e "$(basename $file)\t$duration\t$count\t$mp3Size\t$indexSize";
done

# Indexing time on miaplacidus seems to follow the formula
# Time_in_seconds = 0.66 * Size_Megabytes

