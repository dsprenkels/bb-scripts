#!/bin/sh

if [ -z "$1" ]; then
	echo "usage: trialc.sh dir"
	exit
fi

CXX="g++ -std=c++0x -fsyntax-only -Wall -Wextra -pedantic"

MYDIR="${0%/*}"

for dir in "$@"; do
	for f in "$dir"/*.[Cc] "$dir"/*.[Cc][Pp][Pp]; do
		test -e "$f" && $CXX "${f}"
	done 2> "$dir"/gcc.log
	"$MYDIR/jarify.sh" "$dir" 2> "$dir"/java.log
	for log in "$dir"/gcc.log "$dir"/java.log; do
		test -s "$log" || rm -f "$log"
	done
done
