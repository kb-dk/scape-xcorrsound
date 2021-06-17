SCRIPT_DIR=$(dirname "$(readlink -f -- ${BASH_SOURCE[0]})")
source "$SCRIPT_DIR/setenv.sh"

source /opt/ffmpeg43/enable

# shellcheck disable=SC2154
ismirInput="$baseFolder/ismirInput/"

rm "$ismirInput/"*.cleaned

#How to clean non-existing and broken files from ismirInput
find "$ismirInput" -type f -print0 | \
grep -z -v -F '.git/' | \
  xargs --null -r -Ifile -P36 -n1 bash -c \
    "cat 'file' | \
      xargs -r -Iline bash -c \
        'ffprobe -hide_banner \"line\" &>/dev/null && echo \"line\"' > \"file.cleaned\""

#cleanup
#mkdir -p "$ismirInput/orig"
#mv "$ismirInput/"*.ismir "$ismirInput/orig/"
#for file in "$ismirInput/"*.cleaned; do
#  mv "$file" "$ismirInput/$(basename "$file" .cleaned)"
#done


# Observe changes from another terminal
#cd /data01/larm/mediestream-index-tv/ismirInput/
#for i in $(find -name '*.ismir.cleaned' -cmin +1); do [ -e "$i" ] && diff -q "$(basename "$i" .cleaned)" "$(basename "$i")"; done | sort
#watch 'echo "scale=2;"$(wc -l *.cleaned | grep total | cut -d" " -f3)*100/$(wc -l *.ismir| grep total | cut -d" " -f3) | bc -l'