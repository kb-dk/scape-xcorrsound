SCRIPT_DIR=$(dirname "$(readlink -f -- ${BASH_SOURCE[0]})")
source $SCRIPT_DIR/setenv.sh

source /opt/ffmpeg43/enable
export TmpSoundIndex=/dev/shm/

file="$1"

echo "Starting index for list '$file' at $(date)" | tee "$SCRIPT_DIR/${file}.log"
echo "List consist of $(wc -l "$baseFolder/ismirInput/$file") records" >> "$SCRIPT_DIR/${file}.log"
# Script to ensure that the entire run do not fail if one of the indexers fail
(ismir_build_index  -d "$baseFolder/index/${file}.index" -f "$baseFolder/ismirInput/${file}" || true) &>> "$SCRIPT_DIR/${file}.log"

echo "Finished index for list '$file' at $(date)" | tee -a "$SCRIPT_DIR/${file}.log"


