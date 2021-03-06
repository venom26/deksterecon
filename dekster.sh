#!/bin/sh

echo "$(tput setaf 2)Running Automation to gather data on" $1

mkdir /var/www/html/$1-$3

/usr/local/bin/findomain -t $1 -u /var/www/html/$1-$3/$1-subs.txt
subfinder -d $1 -recursive | tee -a /var/www/html/$1-$3/$1-subs.txt
curl -ss "https://dns.bufferover.run/dns?q=.$1" | jq '.FDNS_A[]' | sed 's/^\".*.,//g' | sed 's/\"$//g'  | sort -u | tee -a /var/www/html/$1-$3/$1-subs.txt
curl -s "https://dns.bufferover.run/dns?q=.$1" | jq -r .RDNS[] 2>/dev/null | cut -d ',' -f2 | grep -o "\w.*$1"  | sort -u | tee -a /var/www/html/$1-$3/$1-subs.txt
curl -s "https://tls.bufferover.run/dns?q=.$1" | jq -r .Results 2>/dev/null | cut -d ',' -f3 |grep -o "\w.*$1" | sort -u | tee -a /var/www/html/$1-$3/$1-subs.txt
amass enum -passive -d $1 | tee -a /var/www/html/$1-$3/$1-subs.txt 
amass enum -active -d $1 | tee -a /var/www/html/$1-$3/$1-subs.txt 
cat /var/www/html/$1-$3/$1-subs.txt | sort -u >> /var/www/html/$1-$3/$1-subs-temp.txt
rm -rf /var/www/html/$1-$3/$1-subs.txt
mv /var/www/html/$1-$3/$1-subs-temp.txt /var/www/html/$1-$3/$1-subs.txt
cat /var/www/html/$1-$3/$1-subs.txt | httpx -silent -threads 200 -csp-probe | anew /var/www/html/$1-$3/$1-subdomains.txt
rm /var/www/html/$1-$3/$1-subs.txt

if [[ "$2" == "port_scan" ]]
then
sed -e 's|^[^/]*//||' -e 's|/.*$||' /var/www/html/$1-$3/$1-subdomains.txt |  naabu -silent -ports full| tee -a /var/www/html/$1-$3/ports-$1.txt;
exit 0;
fi

if [[ "$2" == "screenshots" ]]
then
cat /var/www/html/$1-$3/$1-subdomains.txt | aquatone -out /var/www/html/$1-$3/$1-aqua-out;
exit 0;
fi

if [[ "$2" == "full_scan" ]]
then
python3 dirsearch/dirsearch.py -l /var/www/html/$1-$3/$1-subdomains.txt -e php,html -w ./dirsearch/db/dicc.txt -b -t 120 -x 301,400,401,429,307,503,500,305,412,502 --plain-text-report=/var/www/html/$1-$3/$1-dirsearch.txt
cat /var/www/html/$1-$3/$1-subdomains.txt | httpx -threads 200 -status-code -csp-probe -title -json -o /var/www/html/$1-$3/$1-Httpx-output.json
cat /var/www/html/$1-$3/$1-subdomains.txt | aquatone -out /var/www/html/$1-$3/$1-aqua-out
sed -e 's|^[^/]*//||' -e 's|/.*$||' /var/www/html/$1-$3/$1-subdomains.txt | naabu | tee -a /var/www/html/$1-$3/ports-$1.txt
for url in `cat /var/www/html/$1-$3/$1-subdomains.txt`; do echo $url | subjs | anew /var/www/html/$1-$3/js-$1-temp.txt; done
for url in `cat /var/www/html/$1-$3/$1-subdomains.txt`; do gau $url | grep "\.js" | anew /var/www/html/$1-$3/js-$1-temp.txt; done
cat /var/www/html/$1-$3/js-$1-temp.txt | sort -u >> /var/www/html/$1-$3/js-$1.txt
rm -rf /var/www/html/$1-$3/js-$1-temp.txt
cat /var/www/html/$1-$3/$1-dirsearch.txt | anew /var/www/html/$1-$3/$1-dirsearchPaths.txt;
rm /var/www/html/$1-$3/$1-dirsearch.txt;
exit 0;
fi
