echo "Installing required tools for SecNote"

echo "Installing Httprobe"
go get -u github.com/tomnomnom/httprobe
echo "done"

echo "Installing Waybackurls"
go get github.com/tomnomnom/waybackurls
echo "done"

echo "Installing Anew"
go get -u github.com/tomnomnom/anew
echo "done"

echo "Installing Naabu"
GO111MODULE=on go get -v github.com/projectdiscovery/naabu/v2/cmd/naabu
echo "done"

echo "Installing Subfinder"
GO111MODULE=on go get -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder
echo "done"

echo "Installing MassDNS"
git clone https://github.com/blechschmidt/massdns.git
cd massdns
make
cd ..
mv massdns/bin/massdns /usr/local/bin/
echo "done"

echo "Installing Shuffledns"
GO111MODULE=on go get -v github.com/projectdiscovery/shuffledns/cmd/shuffledns
echo "done"

echo "Installing Gau"
go get -u -v github.com/lc/gau
echo "done"

echo "Installing Httpx"
go get -u -v github.com/projectdiscovery/httpx/cmd/httpx
echo "done"

echo "Installing Findomain"
wget https://github.com/Edu4rdSHL/findomain/releases/latest/download/findomain-linux
chmod +x findomain-linux
mv findomain-linux findomain
sudo cp findomain /usr/local/bin/
echo "done"

echo "Installing Aquatone"
wget https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_amd64_1.7.0.zip
unzip aquatone_linux_amd64_1.7.0.zip
mv aquatone /usr/local/bin
sudo apt install -y chromium-browser
echo "done"

echo "Installing SubJS"
GO111MODULE=on go get -u -v github.com/lc/subjs
echo "Done"

echo "Installing Dirsearch"
git clone https://github.com/maurosoria/dirsearch.git
echo "done"

echo "Installing Amass"
go get -v github.com/OWASP/Amass/v3/...
cd /root/go/src/github.com/OWASP/Amass
go install ./...
cd /deksterecon/
echo "done"
