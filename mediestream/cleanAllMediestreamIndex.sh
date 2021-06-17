SCRIPT_DIR=$(dirname "$(readlink -f -- ${BASH_SOURCE[0]})")
source "$SCRIPT_DIR/setenv.sh"

export TmpSoundIndex=/dev/shm/

echo rm -f "$TmpSoundIndex/"*.wav

echo rm -f "$SCRIPT_DIR"/*.log

mkdir -p "$baseFolder/index"
echo rm -f "$baseFolder/index/"*
