#! /bin/sh

# reconstruct a nice directory structure from a blackboard-provided zip (bb 9.1)

umask 077

if [ -z "$1" ]; then
	echo Usage: bbfix bestand.zip
	exit 1
fi

if [ ! -e "$1" ]; then
	echo Could not find $1
	exit 2
fi

TEMP=EXTRACT
FILTER=" ()-"

unzip -q -o -d "$TEMP" "$1"

for bbfile in "$TEMP"/*; do
	bbfile="${bbfile#*/}"
	basename="${bbfile#*attempt_20[0-9-]*_}"
	studnr="${bbfile#*_}"
	studnr="${studnr%%_[!0-9]*}"
	dir="${studnr}"
	# move files that don't conform to the a seperate folder

	if [ "${studnr##[usefz]*}" ]; then
		dir="attic"
	elif [ "$basename" = "$bbfile" ]; then
		basename="${dir}.txt"
	fi
	#echo DEBUG $bbfile -- $studnr -- $basename
	mkdir -p "$dir"
	mv "$TEMP/${bbfile}" "${dir}/${basename}"
done

rmdir "$TEMP"

