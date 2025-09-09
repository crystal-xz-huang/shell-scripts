#!/usr/bin/env dash

#######################################
# List the filenames in a directory, one per line
#######################################
list() {
  local dir="$1"

  if [ ! -d "$dir" ]; then
    echo "Error: $dir is not a directory" 1>&2
    return 1
  fi

  find "$1" -type f -exec basename {} \;
}

#######################################
# Sort files in a directory by extension
#######################################
sort_by_extension() {
  local dir="$1"

  if [ ! -d "$dir" ]; then
    echo "Error: $dir is not a directory" 1>&2
    return 1
  fi

  for file in "$dir"/*; do
    if [ -f "$file" ]; then
      base=${file##*/}
      ext="${file##*.}"
      pref="${file%.*}"
      echo -e "${ext}\t${file##*/}"
    fi
  done | sort -k1,1 | cut -f2-
}
