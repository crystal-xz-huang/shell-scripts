#!/bin/sh

print_help() {
    echo "Usage: $0 {printpath|dedup}" >&2
    echo
    echo "  print   Print each entry in the PATH environment variable on a new line"
    echo "  dedup   Remove duplicate entries from PATH while preserving order (zsh only)"
    exit 1
}

# Print each entry in the PATH environment variable on a new line
print() {
    echo $PATH | tr : '\n'
}

# Remove duplicate entries from PATH while preserving order
# Note: For zsh only
dedup() {
    typeset -aU path
}

# If first arg matches a function name, call it
if [ "$(type "$1" 2>/dev/null | head -n1)" = "$1 is a function" ]; then
    func=$1; shift
    "$func" "$@"
else
    echo "Usage: $0 {printpath|dedup}" 1>&2
    exit 1
fi
