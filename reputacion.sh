#!/bin/bash

function targeted(){
echo "IPDB Abuse"
echo $(curl -X GET https://www.abuseipdb.com/check/$target --user-agent "Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101 Firefox/91.0" | grep "This IP was reported" | cut -d "." -f1) | sed 's/<[^>]*>//g' >test
echo $(curl -X GET https://www.abuseipdb.com/check/$target --user-agent "Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101 Firefox/91.0" | grep "This IP was reported" | cut -d "." -f2) | sed 's/<[^>]*>//g' | awk '{print $1}' FS=":" >>test
echo "------------------"

clear
cat test
rm test

}

function helppanel(){
	echo -e "\e[0;35m[*]\e[0m\e[1;33mUsage: -t para añadir el objetivo\e[0m\e[0;35m[*]\e[0m\n" 
}

declare -i parameter_counter=0; while getopts ":t:h:" arg;do
	case $arg in
		t)target=$OPTARG; let parameter_counter+=1 ;;
		h)helppanel ;;
	esac
done

if [ $parameter_counter -ne 1 ];then
	helppanel
else
	targeted
fi
