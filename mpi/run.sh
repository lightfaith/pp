#!/bin/bash
processes=10

if [ ! $1 ]; then
	echo "Usage $0 <program>";
	exit;
fi

mpirun -np $processes ./$1 $2
