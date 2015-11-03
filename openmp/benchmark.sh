#!/bin/bash
# Shell script destined to simplify time measuring for different numbers of threads.

threads=32
a=600
b=600
c=600
echo "Matrix multiplication with/out OpenMP ($threads threads):";

	t=`(time ./matrix $a $b $c $threads > /dev/null) 2>&1 | grep real | cut -d'	' -f2`;
	echo "OpenMP: $t"
	t=`(time ./normal $a $b $c > /dev/null) 2>&1 | grep real | cut -d'	' -f2`;
	echo "Normal: $t"
