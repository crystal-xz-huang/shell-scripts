#!/bin/sh

# Count the number of time each different word occurs
# in the files given as arguments, or stdin if no arguments.
#
# Usage: word_frequency.sh <files>

cat "$@" |
tr 'A-Z' 'a-z' |       # map uppercase to lowercase
tr ' ' '\n' |          # put one word per line
tr -cd "a-z'" |        # keep only letters and apostrophes
grep -E -v '^$' |      # remove empty lines
sort |                 # sort words alphabetically
uniq -c |              # count occurrences
sort -rn               # sort by frequency, descending