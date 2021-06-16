SCRIPT_DIR=$(dirname "$(readlink -f -- ${BASH_SOURCE[0]})")
source $SCRIPT_DIR/setenv.sh


echo -n "data indexed (mb): "
ls -1 $baseFolder/ismirInput/*.ismir | \
  xargs -r -i basename {} | \
  xargs -r -i bash -c "grep -s 'Finished' $SCRIPT_DIR/{}.log && echo {}" | \
  xargs -r -i grep '{}' sizeOfAllInputs.tsv | \
  sed 's/^[^\t]*\t//' | \
  tr '\n' '+' | \
  sed 's/+$/\n/' | \
  bc




echo -n "Remaining data to index (mb): "
ls -1 $baseFolder/ismirInput/*.ismir | \
  xargs -r -i basename {} | \
  xargs -r -i bash -c "grep -s 'Finished' $SCRIPT_DIR/{}.log || echo {}" | \
  xargs -r -i grep '{}' sizeOfAllInputs.tsv | \
  sed 's/^[^\t]*\t//' | \
  tr '\n' '+' | \
  sed 's/+$/\n/' | \
  bc

