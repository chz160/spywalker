#!/bin/bash
sudo cp -n spywalker.conf.default /ect/default/spywalker.conf
chmod u+x spywalker.sh
chmod u+x control_loop.sh
chmod u+x capture_hcxdump.sh
chmod u+x capture_kismet.sh
chmod u+x extract.sh
chmod u+x move.sh
chmod u+x online_status.sh

echo "Update APT..."
sudo apt-get update
echo "Installing Dependencys..."
sudo apt-get install -y tmux timeout bc
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
sudo git clone https://github.com/kismetwireless/kismet.git
cd kismet/
#sudo wget http://www.kismetwireless.net/code/kismet-2016-07-R1.tar.xz
#sudo tar -xvf kismet-2016-07-R1.tar.xz
#cd kismet-2016-07-R1/
sudo ./configure
#sudo make dep
sudo make
sudo make suidinstall
sudo usermod -aG kismet $USER
cd ..

echo "Cloning and building Aircrack-ng..."
sudo git clone https://github.com/aircrack-ng/aircrack-ng.git
cd aircrack-ng/
sudo make sqlite=true
sudo make sqlite=true install
cd ..

echo "Cloning and building hcxtools..."
sudo git clone https://github.com/ZerBea/hcxtools.git
cd hcxtools/
sudo make
sudo make install
cd ..

echo "Cloning and building hcxdumptools..."
sudo git clone https://github.com/ZerBea/hcxdumptool.git
cd hcxdumptool/
sudo make
sudo make install
cd ..

echo "Cloning and building driver for rtl8188eus drivers..."
sudo apt-get install raspberrypi-kernel-headers
sudo git clone https://github.com/kimocoder/rtl8188eus.git
cd rtl8188eus
sudo cp realtek_blacklist.conf /etc/modprobe.d/
sudo make
sudo make install
sudo rmmod 8188eu && insmod 8188eu.ko
cd ..

# echo ""
# sudo su
# sudo apt install raspberrypi-kernel-headers git libgmp3-dev gawk qpdf bison flex make
# git clone https://github.com/seemoo-lab/nexmon.git
# cd nexmon
# if test ! -f /usr/lib/arm-linux-gnueabihf/libisl.so.10 ; then
#     cd buildtools/isl-0.10
#     ./configure
#     make
#     make install
#     ln -s /usr/local/lib/libisl.so /usr/lib/arm-linux-gnueabihf/libisl.so.10
# fi
# cd /usr/local/src/nexmon/
# source setup_env.sh
# make
# cd patches/bcm43430a1/7_45_41_46/nexmon/
# make
# make backup-firmware
# make install-firmware
# cd /usr/local/src/nexmon/utilities/nexutil/
# make
# make install
# apt-get remove wpasupplicant
# mv "/lib/modules/4.14.98+/kernel/drivers/net/wireless/broadcom/brcm80211/brcmfmac/brcmfmac.ko" "/lib/modules/4.14.98+/kernel/drivers/net/wireless/broadcom/brcm80211/brcmfmac/brcmfmac.ko.orig"
# cp /usr/local/src/nexmon/patches/bcm43430a1/7_45_41_46/nexmon/brcmfmac_4.14.y-nexmon/brcmfmac.ko "/lib/modules/4.14.98+/kernel/drivers/net/wireless/broadcom/brcm80211/brcmfmac/"
# depmod -a
# exit

sudo rm -rf hcxdumptool hcxtools aircrack-ng kismet rtl8188eus # cleaning up
cd ~

sudo airodump-ng-oui-update
#cd scripts
#chmod +x airmon-ng
#cp airmon-ng /usr/bin/airmon-ng
#cd ~/
# echo "Grabbing Airoscript From SVN"
# sudo svn co http://svn.aircrack-ng.org/branch/airoscript-ng/ airoscript-ng
# cd airoscript-ng
# sudo make

cd ~/

wget -O manuf "https://code.wireshark.org/review/gitweb?p=wireshark.git;a=blob_plain;f=manuf"
sudo cp manuf /etc/

echo "done"