SCRIPT_DIR=$(dirname "$(readlink -f -- ${BASH_SOURCE[0]})")

threads=$1

inputFiles=$(ls -1 /data01/larm/mediestream-index/ismirInput/)

echo "$inputFiles" | \
  xargs -n1 -P$threads -r -i $SCRIPT_DIR/ismirMedieStreamBuildIndex.sh '{}'