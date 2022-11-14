#!/bin/bash
trap ctrl_c INT
function ctrl_c(){
	echo -e "\e[0;35m[*]\e[0m\e[1;33mSaliendo...\e[0m\e[0;35m[*]\e[0m\n"
	exit 0
	tput cnorm
}

function autowifi(){
inter=$(iw dev | grep -i interface | awk '{print $2}')

lista=$(iwlist $inter scan | grep -i essid)

echo "$lista\n"

#ssid
echo -ne "\e[0;35m[*]\e[0m\e[1;33mSelecciona el nombre de tu wifi\e[0m\e[0;35m[*]\e[0m\n"; read ssid
#passwd
echo -ne "\e[0;35m[*]\e[0m\e[1;33mPon tu contraseña\e[0m\e[0;35m[*]\e[0m\n"; read pass

sudo wpa_passphrase $ssid $pass > /tmp/mired.conf
sudo wpa_supplicant -B -i $inter -c /tmp/mired.conf
sudo dhclient
final=$(ifconfig | grep wlp5s0 -1 | grep inet | awk '{print $2}')
echo -e "\e[1;35m[*]\e[0m\e[1;31m$final\e[0m"
}
#Main function
if [ "$(id -u)" == "0" ]; then
 autowifi
else

	echo -e "\e[0;35m[*]\e[0m\e[1;33mNecesitas ser root para ejecutarlo\e[0m\e[0;35m[*]\e[0m\n"
fi
