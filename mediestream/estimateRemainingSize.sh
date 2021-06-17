SCRIPT_DIR=$(dirname "$(readlink -f -- ${BASH_SOURCE[0]})")
source "$SCRIPT_DIR/setenv.sh"


echo -n "data indexed (mb): "
# shellcheck disable=SC2154
find "$baseFolder/ismirInput/" -type f -name "*.ismir" -maxdepth 1 -print0 | \
  xargs -n1 --null -r -i basename "{}" | \
  xargs -n1 -r -i bash -c "grep -s 'Finished' '$SCRIPT_DIR/{}.log' && echo '{}'" | \
  xargs -n1 -r -i grep '{}' sizeOfAllInputs.tsv | \
  sed 's/^[^\t]*\t//' | \
  tr '\n' '+' | \
  sed 's/+$/\n/' | \
  bc




echo -n "Remaining data to index (mb): "
find "$baseFolder/ismirInput/" -type f -name "*.ismir" -maxdepth 1 -print0 | \
  xargs --null -n1 -r -i basename "{}" | \
  xargs -n1 -r -i bash -c "grep -s 'Finished' '$SCRIPT_DIR/{}.log' || echo '{}'" | \
  xargs -n1 -r -i grep '{}' sizeOfAllInputs.tsv | \
  sed 's/^[^\t]*\t//' | \
  tr '\n' '+' | \
  sed 's/+$/\n/' | \
  bc

