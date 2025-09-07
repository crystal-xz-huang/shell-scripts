#!/usr/bin/env bash

#==============================================================================
# Print the directory tree of a specified folder
# tree.sh
#
# A clone of the tree utility with additional features
# such as displaying file sizes, sorting directories before files,
#
# Notes: Requires the 'file' and 'stat' commands
#
# Crystal Huang
#
#------------------------------------------------------------------------------
# USAGE:
#   tree [OPTIONS] [directory]
#------------------------------------------------------------------------------
# OPTIONS:
#   -s          Print the size of each file in bytes.
#   -h          Print the size of each file in a human-readable way
#               (e.g., appending a size letter for kilobytes (K), megabytes (M),
#               gigabytes (G), terabytes (T), petabytes (P), and exabytes (E)).
#   -L level    Max display depth of the directory tree.
#   -o file     Send output to the specified file.
#   --dirsfirst List directories before files.
#   --help      Display this help message.
#------------------------------------------------------------------------------
# EXAMPLES:
#   Print the tree with file sizes in bytes:
#       tree -s /path/to/directory
#
#   Print the tree with file sizes in a human-readable way:
#       tree -h /path/to/directory
#
#   Print the tree with a maximum depth of 2:
#       tree -L 2 /path/to/directory
#
#   Print the tree with directories listed before files:
#       tree --dirsfirst /path/to/directory
#==============================================================================

if [ -z "$1" ]; then
  echo "Usage: $0 /path/to/folder"
  exit 1
fi

# Define ANSI color codes
RESET='\033[0m'
RED='\033[0;91m'
GREEN='\033[0;92m'
BLUE='\033[1;94m'
CYAN='\033[1;96m'

# Define a list of MIME types for compressed archives
ARCHIVE_MIME_TYPES=(
    "application/zip"                                # .zip
    "application/x-tar"                              # .tar
    "application/gzip"                               # .gz
    "application/x-bzip2"                            # .bz2
    "application/x-xz"                               # .xz
    "application/x-7z-compressed"                    # .7z
    "application/x-rar"                              # .rar
    "application/java-archive"                       # .jar
    "application/x-archive"                          # .ar
    "application/vnd.android.package-archive"        # .apk
    "application/vnd.debian.binary-package"          # .deb
    "application/x-redhat-package-manager"           # .rpm
    "application/vnd.microsoft.portable-executable"  # .exe
    "application/vnd.ms-cab-compressed"              # .cab
)

# Default values for options
print_size=false
max_depth=-1
human_readable_size=false
output_file=""
use_color=true
dirs_first=false

highlight() {
    local name=$1
    local color=$2
    if $use_color; then
        echo -e "${color}${name}${RESET}"
    else
        echo "$name"
    fi
}

highlight_link() {
    local name=$1
    local target=$2
    if $use_color; then
        echo -e "${CYAN}${name}${RESET} -> $(highlight_item "$target")"
    else
        echo "$name -> $target"
    fi
}

highlight_item() {
    local item=$1
    local display_name

    display_name=$(basename "$item")

    if [ -d "$item" ]; then
        highlight "$display_name" "$BLUE"
    elif [ -x "$item" ]; then
        highlight "$display_name" "$GREEN"
    elif is_archive "$item"; then
        highlight "$display_name" "$RED"
    else
        echo "$display_name"
    fi
}

is_archive() {
    local item=$1
    local mime_type

    mime_type=$(file --mime-type -b "$item")
    for type in "${ARCHIVE_MIME_TYPES[@]}"; do
        if [[ "$mime_type" == "$type" ]]; then
            return 0
        fi
    done
    return 1
}

get_human_readable_size() {
    local size=$1
    local units=("B" "K" "M" "G" "T" "P" "E")
    local i=0

    while [ "$(echo "$size >= 1024" | bc)" -eq 1 ] && [ $i -lt ${#units[@]} ]; do
        size=$(echo "$size / 1024" | bc -l)
        size=$(printf "%.0f" "$size")  # Convert to integer for the next iteration
        i=$((i + 1))
    done

    printf "%.1f%s" "$size" "${units[$i]}"
}

get_size() {
    local item=$1
    local size

    size=$(stat -c%s "$item")
    if [ "$human_readable_size" = true ]; then
        echo " ($(get_human_readable_size "$size"))"
    else
        echo " ($size bytes)"
    fi
}

get_display_name() {
    local item=$1
    local display_name
    local size_info=""

    display_name=$(basename "$item")

    if [ "$print_size" = true ]; then
        size_info=$(get_size "$item")
    fi

    if [ -d "$item" ]; then
        display_name=$(highlight "$display_name" "$BLUE")
    elif [ -L "$item" ]; then
        local target
        target=$(readlink "$item")
        display_name=$(highlight_link "$display_name" "$target")
    else
        display_name=$(highlight_item "$item")
    fi

    echo "$display_name$size_info"
}

print_tree() {
    local dir=$1
    local prefix=$2
    local depth=$3
    local output=$4

    # Stop if max depth is reached
    if [ "$max_depth" -ne -1 ] && [ "$depth" -ge "$max_depth" ]; then
        return
    fi

    # List all files and directories in the current directory
    local items=("$dir"/*)

    # Handle empty directories
    if [ ! -e "${items[0]}" ]; then
        echo "${prefix}(empty)" >> "$output"
        return
    fi

    if $dirs_first; then
        # Separate directories and files
        local dirs=()
        local files=()
        for item in "${items[@]}"; do
            if [ -d "$item" ]; then
                dirs+=("$item")
            else
                files+=("$item")
            fi
        done
        items=("${dirs[@]}" "${files[@]}")
    fi

    local last_index=$((${#items[@]} - 1))

    for i in "${!items[@]}"; do
        local item="${items[$i]}"
        local new_prefix="${prefix}│   "

        # Determine the correct prefix for the next level
        if [ "$i" -eq $last_index ]; then
            new_prefix="${prefix}    "
        fi

        # Get the display name with colors
        local display_name
        display_name=$(get_display_name "$item")

        # Print the current item
        echo -e "${prefix}└── ${display_name}" >> "$output"

        # Recursively print the tree for directories
        if [ -d "$item" ]; then
            print_tree "$item" "$new_prefix" $((depth + 1)) "$output"
        fi
    done
}

print_help() {
    echo "Usage: $(basename "$0") [OPTIONS] [directory]"
    echo ""
    echo "Options:"
    echo "  -s          Print the size of each file in bytes"
    echo "  -h          Print the size of each file in a human-readable way"
    echo "              (e.g., appending a size letter for kilobytes (K), megabytes (M),"
    echo "              gigabytes (G), terabytes (T), petabytes (P), and exabytes (E))"
    echo "  -L level    Max display depth of the directory tree"
    echo "  -o file     Send output to the specified file"
    echo "  --dirsfirst List directories before files"
    echo "  --help      Display this help message"
}

# Parse options
while getopts "sho:L:-:" opt; do
    case $opt in
        s) print_size=true ;;
        h) print_size=true; human_readable_size=true ;;
        L) max_depth=$OPTARG ;;
        o) output_file=$OPTARG; use_color=false ;;
        -)
            case $OPTARG in
                help) print_help; exit 0 ;;
                dirsfirst) dirs_first=true ;;
                *) echo "Invalid option: --$OPTARG"; print_help; exit 1 ;;
            esac ;;
        *) echo "Invalid option: -$OPTARG"; print_help; exit 1 ;;
    esac
done
shift $((OPTIND - 1))

# Check if a directory is passed as an argument, otherwise use the current directory
if [ $# -eq 0 ]; then
    dir="."
else
    dir="$1"
fi

# Initialize the output file or standard output
if [ -n "$output_file" ]; then
    echo "." > "$output_file"
else
    output_file="/dev/stdout"
    echo "."
fi

# Start the tree printing
print_tree "$dir" "" 0 "$output_file"
