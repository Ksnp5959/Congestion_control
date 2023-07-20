set terminal png
set output 'Result.png'
set xrange [0.0:100.0]
set xlabel "Time(in seconds)"
set autoscale
set yrange [0:5000]
set ylabel "Throughput(in Kbps)"
set grid
set style data linespoints
plot "thrptGraph1" using 1:2 title "TCP Throughput" lt rgb "blue" ,\
 "thrptGraph2" using 1:2 title "UDP Throughput" lt rgb "red"

