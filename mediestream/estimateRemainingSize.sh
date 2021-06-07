

echo -n "data indexed (mb): "
ls -1 /data01/larm/mediestream-index/ismirInput/*.ismir | \
  xargs -r -i basename {} | \
  xargs -r -i bash -c "grep -s 'Finished' ~/mediestream_index/{}.log && echo {}" | \
  xargs -r -i grep '{}' sizeOfAllInputs.tsv | \
  sed 's/^[^\t]*\t//' | \
  tr '\n' '+' | \
  sed 's/+$/\n/' | \
  bc




echo -n "Remaining data to index (mb): "
ls -1 /data01/larm/mediestream-index/ismirInput/*.ismir | \
  xargs -r -i basename {} | \
  xargs -r -i bash -c "grep -s 'Finished' ~/mediestream_index/{}.log || echo {}" | \
  xargs -r -i grep '{}' sizeOfAllInputs.tsv | \
  sed 's/^[^\t]*\t//' | \
  tr '\n' '+' | \
  sed 's/+$/\n/' | \
  bc

