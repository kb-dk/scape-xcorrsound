SCRIPT_DIR=$(dirname "$(readlink -f -- ${BASH_SOURCE[0]})")
source "$SCRIPT_DIR/setenv.sh"

# shellcheck disable=SC2154
[ -e "$baseFolder/sizeOfAllInputs.tsv" ] || (\
  find $baseFolder/ismirInput/ -maxdepth 1 -name "*.ismir"  -print0 | \
  xargs --null -r -i basename "{}" | \
  while read -r file; do
    size=$(cat "$baseFolder/ismirInput/$file" | \
      tr '\n' '\0' | \
      du -chm --files0-from=- | \
      grep 'total' | \
      cut -f1);
    echo -e "$file\t$size";
  done | \
  tee "$baseFolder/sizeOfAllInputs.tsv")



echo -n "data indexed (mb): "

find "$baseFolder/ismirInput/" -maxdepth 1 -type f -name "*.ismir"  -print0 | \
  xargs -n1 --null -r -i basename "{}" | \
  xargs -n1 -r -i bash -c "grep -s 'Finished' '$SCRIPT_DIR/{}.log' && echo '{}'" | \
  xargs -n1 -r -i grep '{}' "$baseFolder/sizeOfAllInputs.tsv" | \
  sed 's/^[^\t]*\t//' | \
  tr '\n' '+' | \
  sed 's/+$/\n/' | \
  bc




echo -n "Remaining data to index (mb): "
find "$baseFolder/ismirInput/" -maxdepth 1 -type f -name "*.ismir"  -print0 | \
  xargs --null -n1 -r -i basename "{}" | \
  xargs -n1 -r -i bash -c "grep -s 'Finished' '$SCRIPT_DIR/{}.log' || echo '{}'" | \
  xargs -n1 -r -i grep '{}' "$baseFolder/sizeOfAllInputs.tsv" | \
  sed 's/^[^\t]*\t//' | \
  tr '\n' '+' | \
  sed 's/+$/\n/' | \
  bc

