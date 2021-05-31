SCRIPT_DIR=$(dirname "$(readlink -f -- ${BASH_SOURCE[0]})")


export TmpSoundIndex=/dev/shm/

echo rm -f "$TmpSoundIndex/"*.wav

echo rm -f "$SCRIPT_DIR"/*.log

mkdir -p "/data01/larm/mediestream-index/index"
echo rm -f "/data01/larm/mediestream-index/index/"*
