SCRIPT_DIR=$(dirname "$(readlink -f -- ${BASH_SOURCE[0]})")

source /opt/ffmpeg43/enable
export TmpSoundIndex=/dev/shm/

file="$1"

echo "Starting index for list '$file' at $(date)" | tee "$SCRIPT_DIR/${file}.log"
echo "List consist of $(wc -l "$file") records" >> "$SCRIPT_DIR/${file}.log"
# Script to ensure that the entire run do not fail if one of the indexers fail
(ismir_build_index  -d "/data01/larm/mediestream-index/index/${file}.index" -f "/data01/larm/mediestream-index/ismirInput/${file}" || true) &>> "$SCRIPT_DIR/${file}.log"

echo "Finished index for list '$file' at $(date)" | tee -a "$SCRIPT_DIR/${file}.log"


