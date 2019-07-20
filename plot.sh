#!/usr/bin/env bash
#
# Create a CSV containing the occurences of a given word in files in a given
# directory.
#
# $ ./plot.sh twitter
#

query="$1"
src="subtitles"
declare -A dates

for f in ${src}/*.xml; do
	date=$(basename $f .xml | cut -d - -f 1)
	date="${date:0:4}-${date:4:2}"
	id=$(basename $f .xml | cut -d - -f 2)
	num=$(cat $f | grep -iow "${query}" | wc -l | tr -d "[:space:]")
	dates["${date}"]=$((dates[${date}] + num))
done

for date in "${!dates[@]}"; do
	echo "${date};${dates[$date]}"
done | sort > "${query}.csv"
