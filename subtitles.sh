#!/usr/bin/env bash
#
# Download tagesschau subtitles.
#

set pipefail

parallel=10
num=1000
out="subtitles"
base="https://www.tagesschau.de"

if [ ! -d "${out}" ]; then
	mkdir "${out}"
fi

for days in $(seq ${num}); do
	(
		d_en=$(date -v "-${days}d" +%Y%m%d)
		d_de=$(date -v "-${days}d" +%d.%m.%Y)
		echo "${d_de}"
		url=$(curl -s "${base}/multimedia/video/videoarchiv2~_date-${d_en}.html" \
			| pup ".dachzeile:contains(\"${d_de} 20:00 Uhr\") + .headline a:contains(\"tagesschau\") attr{href}" \
			| grep "/ts-" \
			| head -n 1)
		id=$(echo ${url} | grep -o '[0-9]\+')
		json=$(curl -s "${base}${url}" \
			| pup --plain "iframe attr{data-ctrl-iframe}" \
			| tr \' \" \
			| jq -r ".action.default.src" \
			| sed 's/ardplayer_autoplay-true/mediajson/g' \
			| sed 's/.html/.json/g')
		subtitle=$(curl -s "${base}${json}" \
			| jq -r "._subtitleUrl")
		wget -q -O "${out}/${d_en}-${id}.xml" "${base}${subtitle}"
	) &

	if [[ $(jobs -r -p | wc -l) -gt ${parallel} ]]; then
		wait -n
	fi
done
wait
