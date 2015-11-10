#!/bin/bash
h1=15
w2=8
h2=20

processes=$(($w2*$h1+1))
echo "Running ./matrix for $processes processes."

#if [ ! $1 ]; then
#	echo "Usage $0 <program>";
#	exit;
#fi

echo -e "Creating $processes processes...\r";
mpirun -np $processes ./matrix $h1 $w2 $h2
#./matrix $h1 $w2 $h2
