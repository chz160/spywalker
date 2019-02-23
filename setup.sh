#!/bin/bash
echo "Update APT"
sudo apt-get update
echo "Installing Dependencys"
sudo apt-get install -y tmux timeout
sudo apt-get install -y libssl-dev subversion iw libnl-dev macchanger sqlite3 libsqlite3-dev reaver
sudo apt-get install -y libnl-3-dev libnl-genl-3-dev
sudo apt-get install -y libcurl4-openssl-dev zlib1g-dev libpcap-dev
#For GPS
sudo apt-get install -y gpsd libncurses5-dev libpcap-dev tcpdump libnl-dev gpsd-clients python-gps
#For Kismet
sudo apt-get install -y build-essential git libmicrohttpd-dev pkg-config zlib1g-dev libnl-3-dev libnl-genl-3-dev libcap-dev libpcap-dev libnm-dev libdw-dev libsqlite3-dev libprotobuf-dev libprotobuf-c-dev protobuf-compiler protobuf-c-compiler libsensors4-dev libusb-1.0-0-dev
sudo apt-get install -y python python-setuptools python-protobuf python-requests python-pip
sudo apt-get install -y librtlsdr0 python-usb
sudo pip install paho-mqtt
# For GISKismet
sudo apt-get install libxml-libxml-perl libdbi-perl libdbd-sqlite3-perl

echo "Downloading and building Kismet..."
cd /usr/local/src
sudo wget http://www.kismetwireless.net/code/kismet-2016-07-R1.tar.xz
sudo tar -xvf kismet-2016-07-R1.tar.xz
cd kismet-2016-07-R1/
sudo ./configure
sudo make dep
sudo make
sudo make suidinstall
sudo usermod -aG kismet $USER
cd ..

sudo git clone https://bitbucket.org/cbless/kismetanalyzer.git
cd kismetanalyzer/
sudo pip install -r requirements.txt
sudo python setup.py install
cd ..

echo "Cloning and building PacketQ..."
sudo apt-get install -y zlib1g-dev automake
sudo git clone https://github.com/DNS-OARC/PacketQ.git
cd PacketQ/
sudo sh autogen.sh
sudo ./configure
sudo make
sudo make install
cd ..

echo "Cloning and building Aircrack-ng..."
git clone https://github.com/aircrack-ng/aircrack-ng.git
cd aircrack-ng/
make sqlite=true
make sqlite=true install
cd ..

echo "Cloning and building hcxtools..."
git clone https://github.com/ZerBea/hcxtools.git
cd hcxtools/
make
sudo make install
cd ..

echo "Cloning and building hcxdumptools..."
git clone https://github.com/ZerBea/hcxdumptool.git
cd hcxdumptool/
make
sudo make install
cd ..

rm -rf hcxdumptool hcxtools aircrack-ng kismet-2016-07-R1 kismetanalyzer PacketQ # cleaning up

sudo airodump-ng-oui-update
cd scripts
chmod +x airmon-ng
cp airmon-ng /usr/bin/airmon-ng
cd ~/
echo "Grabbing Airoscript From SVN"
sudo svn co http://svn.aircrack-ng.org/branch/airoscript-ng/ airoscript-ng
cd airoscript-ng
sudo make

cd ~/

wget -O manuf "https://code.wireshark.org/review/gitweb?p=wireshark.git;a=blob_plain;f=manuf"
sudo cp manuf /etc/

echo "done"