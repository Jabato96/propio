!/bin/bash

function targeted(){

curl -X GET https://www.abuseipdb.com/check/$target --user-agent "Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101 Firefox/91.0" > /tmp/test
cat /tmp/test | grep "This IP was reported" | cut -d "." -f1 | sed 's/<[^>]*>//g' > /tmp/test2
cat /tmp/test | grep "This IP was reported" | cut -d "." -f2 | sed 's/<[^>]*>//g' | awk '{print $1}' FS=":" | xargs echo "." >>/tmp/test2
cat /tmp/test2 | xargs > /tmp/test3
sleep 1
comp=$(wc -c /tmp/test3 | awk '{print $1}')
if [ $comp -lt 58 ]; then
echo "No tiene mala reputacion" > /tmp/test3
fi


echo "ISP: "$(cat /tmp/test | grep -i "<th>Domain Name" -A 2 |xargs | awk '{print $4}' FS=">") >> /tmp/test3
echo "Pais: "$(cat /tmp/test | grep -i "<th>Country" -A 3 | tail -n1) >> /tmp/test3


clear
echo "IPDB Abuse"
echo "------------------"
cat /tmp/test3
rm /tmp/test
rm /tmp/test2
rm /tmp/test3
echo "------------------"
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

