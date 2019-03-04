#!/bin/bash
sudo su
echo -e "\e[32mCopying conf file to /etc/default directory...\e[0m"
cp -n spywalker.conf.default /etc/default/spywalker.conf

echo -e "\e[32mSetting execute permission on script files...\e[0m"
chmod u+x spywalker.sh
chmod u+x control_loop.sh
chmod u+x capture_hcxdump.sh
chmod u+x capture_kismet.sh
chmod u+x extract.sh
chmod u+x move.sh
chmod u+x online_status.sh

echo -e "\e[32mUpdate ATP...\e[0m"
apt-get update
echo -e "\e[32mInstalling Dependencys...\e[0m"
#For Aircrack
apt-get install -y \
    tmux timeout bc build-essential raspberrypi-kernel-headers \
    libssl-dev subversion iw libnl-dev macchanger sqlite3 libsqlite3-dev reaver \
    install -y libnl-3-dev libnl-genl-3-dev \
    libcurl4-openssl-dev zlib1g-dev libpcap-dev \;
#For GPS
apt-get install -y gpsd libncurses5-dev tcpdump gpsd-clients python-gps
#For Kismet
apt-get install -y \
    libmicrohttpd-dev pkg-config libcap-dev libnm-dev libdw-dev libprotobuf-dev \
    libprotobuf-c-dev protobuf-compiler protobuf-c-compiler libsensors4-dev libusb-1.0-0-dev
    python python-setuptools python-protobuf python-requests python-pip \
    librtlsdr0 python-usb \;
pip install paho-mqtt

echo -e "\e[32mDownloading and building Kismet...\e[0m"
cd /usr/local/src
git clone https://github.com/kismetwireless/kismet.git
cd kismet/
./configure
make
make suidinstall
usermod -aG kismet $USER
cd ..

echo -e "\e[32mCloning and building Aircrack-ng...\e[0m"
git clone https://github.com/aircrack-ng/aircrack-ng.git
cd aircrack-ng/
make sqlite=true
make sqlite=true install
cd ..

echo -e "\e[32mCloning and building hcxtools...\e[0m"
git clone https://github.com/ZerBea/hcxtools.git
cd hcxtools/
make
make install
cd ..

echo -e "\e[32mCloning and building hcxdumptools...\e[0m"
git clone https://github.com/ZerBea/hcxdumptool.git
cd hcxdumptool/
make
make install
cd ..

echo -e "\e[32mCloning and building driver for rtl8188eus drivers...\e[0m"
git clone https://github.com/kimocoder/rtl8188eus.git
cd rtl8188eus
cp realtek_blacklist.conf /etc/modprobe.d/
make
make install
rmmod 8188eu && insmod 8188eu.ko
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

echo -e "\e[32mCleaning up source directory...\e[0m"
rm -rf hcxdumptool hcxtools aircrack-ng kismet rtl8188eus # cleaning up
cd ~

airodump-ng-oui-update
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
cp manuf /etc/

echo "done"
exit