#! /bin/bash

#CtrlC
trap ctrl_c INT
function ctrl_c(){
	echo -e "\e[0;35m[*]\e[0m\e[1;33mSaliendo...\e[0m\e[0;35m[*]\e[0m\n"
	exit 0
	tput cnorm
}

#Function 1nmap
function scan(){
	clear
	tput civis
	ttl=$(ping -c1 $objetivo 2>/dev/null | grep ttl | cut -d "=" -f3 | cut -d " " -f1)
	if [[ $ttl -gt 64 ]]
		then
		echo "SO:Windows"
	else
		echo "SO: LINUX"
	fi

	sudo nmap -p- -sS --min-rate 5000 --open -n -Pn $objetivo -oG ports
	puertos="$(cat ports | grep -oP '\d{1,5}/open' | awk '{print $1}' FS='/' | xargs | tr ' ' ',')"
	sudo nmap -p $puertos -sCV $objetivo > resultados
	echo $puertos > scanned

	

	while read line;do
		if [[ $line == *80* ]]
		then
			whatweb http://$objetivo > tmp2
		fi
		if [[ $line == *443* ]]
		then
			whatweb https://$objetivo > tmp2
		fi
	done < scanned

	if [ -e tmp2 ]
	then
		printf "\n:::::::::Whatweb::::::::::\n" >> resultados
		cat tmp2 >>resultados
		rm tmp2
		batcat resultados
		rm ports
		rm resultados
	fi
}
#full
function fullscan(){
	if [ $fscan -ge 1 ];then
	while read line;do
		if [[ $line == *80* ]]
		then
			gobuster dir -u http://$objetivo/ -w /usr/share/wordlists/dirbuster/directory-list-2.3-small.txt -s "200,403,301,204,302,401,307" > tmp1
		fi
		if [[ $line == *443* ]]
		then
			gobuster dir -u https://$objetivo/ -w /usr/share/wordlists/dirbuster/directory-list-2.3-small.txt -s "200,403,301,204,302,401,307" > tmp1
		fi
	done < scanned
	if [ -e tmp1 ]
		then
			printf "\n:::::::::Directorios::::::::::\n" > resultados2
			cat tmp1 >>resultados2
			batcat resultados2
			rm tmp1
			rm resultados2
		fi
	fi
}

#Helppanel
function helppanel(){
	echo -e "\e[0;35m[*]\e[0m\e[1;33mUsage: -t para añadir el objetivo\n -f1 para hacer el full scan\e[0m\e[0;35m[*]\e[0m\n " 
}

#Main function
if [ "$(id -u)" == "0" ]; then
	declare -i parameter_counter=0; declare -i fscan=0; while getopts ":t:h:f:" arg;do
		case $arg in
			t)objetivo=$OPTARG; let parameter_counter+=1 ;;
			h)helppanel ;;
			f)fullscan; let fscan+=2;;
		esac
	done

	if [ $parameter_counter -ne 1 ];then
		helppanel
	else
		scan
		fullscan
		tput cnorm
	fi
else

	echo -e "\e[0;35m[*]\e[0m\e[1;33mNecesitas ser root para ejecutarlo\e[0m\e[0;35m[*]\e[0m\n"
fi
