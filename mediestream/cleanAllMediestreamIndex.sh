SCRIPT_DIR=$(dirname "$(readlink -f -- ${BASH_SOURCE[0]})")


export TmpSoundIndex=/dev/shm/

rm -f "$TmpSoundIndex/"*.wav

rm -f "$SCRIPT_DIR"/*.log

mkdir -p "/data01/larm/mediestream-index/index"
rm -f "/data01/larm/mediestream-index/index/"*
