#!/bin/bash
#
#	+-----------------------------------------------------------------------+
#	| description:	this script will count the number of items to process	|
#	|		and print a progress bar.				|
#	| date:		February 7th, 2018					|
#	| author:	Sascha Reimann						|
#	| git:		https://github.com/s-reimann/progressbar.sh		|
#	+-----------------------------------------------------------------------+
#
total_steps="$(($(tput cols) - 8))"
total=$(find /dev/|wc -l)
if (( total < total_steps )); then
	total_steps="$total"
fi
threshold=$(( total / total_steps - 1 ))

for i in $(find /dev/); do
	if [ -f $i ] ; then sleep 0.01; fi

	(( count++ ))
	if (( $(echo "$count $threshold" | awk '{print ($1 > $2)}') )); then
		threshold=$(awk "BEGIN {print $threshold + $total / $total_steps}")
		if (( step < total_steps )); then
			(( step++ ))
			percentage=$(( step * 100 / total_steps ))
			digits=$(echo "${#percentage}")
			echo -en "\r|$(printf %${step}s |tr " " ":")$(printf %$(( total_steps - step ))s)| ${percentage}$(printf %$(( 3 - digits))s |tr " " " ")%"
		fi
	fi
done
echo
