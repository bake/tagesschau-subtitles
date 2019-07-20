load 'set1.pal'
unset border
set datafile separator ";"
set format x "%m.%Y"
set grid ytics
set output "twitter.png"
set term pngcairo size 800,400
set tic scale 0
set timefmt "%Y-%m"
set title "Number of occurences in tagesschau-subtitles per month"
set xdata time
set xlabel "Date"
set xtics rotate
set ylabel "Occurrences"
plot \
	"internet.csv" using 1:2 with lines ls 1 t "Internet", \
	"twitter.csv" using 1:2 with lines ls 2 t "Twitter"
