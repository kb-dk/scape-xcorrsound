SCRIPT_DIR=$(dirname "$(readlink -f -- ${BASH_SOURCE[0]})")
source "$SCRIPT_DIR/setenv.sh"

export TmpSoundIndex=/dev/shm/

threads=$1

# shellcheck disable=SC2154
mkdir -p "$baseFolder/index"

#First, we find all the crashed runs
# We delete the index files, as we will have to recreate them from scratch
grep -l 'Segmentation' "$SCRIPT_DIR/"*.log | \
  xargs -r -i basename "{}" .log | \
  xargs -r -i rm -f "$baseFolder/index/{}.index" "$baseFolder/index/{}.index.map"

# move the error logs to errors, so they will not be regarded as completed below
mkdir -p "$SCRIPT_DIR/errors"
grep -l 'Segmentation' "$SCRIPT_DIR/"*.log | xargs -r -i mv "{}" "$SCRIPT_DIR/errors"

#Search for Finished Index in log files. These are the ones we do NOT need to recreate
completedIndexes=$(grep -l "Finished index" "$SCRIPT_DIR/"*.log | xargs -r -i basename '{}' .log | sort)

#This is the complete set input files
inputFiles=$(ls -1 "$baseFolder/ismirInput/" | xargs -r -i basename '{}' | sort)

#Remove completedIndexes from Inputfiles to generate the list of indexes we must create
indexesToDo=$(comm -23 <(echo "$inputFiles") <(echo "$completedIndexes"))

#Ensure that these future indexes do not already have a log file or index we would risk appending to
echo "$indexesToDo" | xargs -r -i -n1 rm -f "$SCRIPT_DIR/{}.log" "$baseFolder/index/{}.index" "$baseFolder/index/{}.index.map"

rm -rf "${TmpSoundIndex:?}/"*

#Log when we started
date

#Start the indexing
echo "$indexesToDo" | \
  xargs -n1 -P$threads -r -i "$SCRIPT_DIR/ismirMedieStreamBuildIndex.sh" '{}'

#Log when we completed
date