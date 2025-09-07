#!/usr/bin/env dash
#
# Count the number of time each different word occurs
# in the files given as arguments, or stdin if no arguments.
#
# Usage: word_frequency.sh <files>
# Example: word_frequency.sh dracula.txt
#
# Crystal Huang <crystalhuang@y7mail.com>
#
# Notes :
# - first 2 tr commands could be combined
# - sed 's/ /\n/g' could be used instead of tr ' ' '\n'
# - sed "s/[^a-z']//g" could be used instead of tr -cd "a-z'"
#==============================================================================

cat "$@" | # tr doesn't take filenames as arguments
tr 'A-Z' 'a-z'| # map uppercase to lower case, better - tr '[:upper:]' '[:lotr ' ' '\n' | # convert to one word per line
tr -cd "a-z'" | # remove all characters except a-z and '
grep -E -v '^$' | # remove empty lines
sort | # place words in alphabetical order
uniq -c | # count how many times each word occurs
sort -rn # order in reverse frequency of occurrence
