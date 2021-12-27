#! /bin/bash

trap ctrl_c INT
function ctrl_c(){
	echo -e "\e[0;35m[*]\e[0m\e[1;33mSaliendo...\e[0m\e[0;35m[*]\e[0m\n"
	exit 0
	tput cnorm
}

function targeted(){
tput civis


ttl=$(ping -c1 $target 2>/dev/null | grep ttl | cut -d "=" -f3 | cut -d " " -f1)
if [ $ttl -lt 64 ]; then
	var=$(echo "Linux")
else
	var=$(echo "Windows")
fi
rm ttl.txt
#clear


echo -e "\e[1;31mObjetivo = $target | $var \e[0m"
echo -e "-----------------------------"
for port in $(seq 1 65535);do
	timeout 1 bash -c "echo '' > /dev/tcp/$target/$port" 2>/dev/null && echo -e "\e[0;35m[*]\e[0m\e[1;33m[*] Puerto: $port -> OPEN\e[0m\n" &
	done
tput cnorm
}

function helppanel(){
	echo -e "\e[0;35m[*]\e[0m\e[1;33mUsage: -t para añadir el objetivo\e[0m\e[0;35m[*]\e[0m\n" 
}

#Main function
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
