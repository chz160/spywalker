#!/bin/bash
if [[ `id -u` -ne 0 ]] ; then 
    echo "Please run as root/sudo."; 
    exit 1 ; 
fi

if [ -f "/etc/default/spywalker.conf"]; then
    echo -e "\e[32mConf file already exists in /etc/default directory.\e[0m"
else
    echo -e "\e[32mCopying conf file to /etc/default directory...\e[0m"
    cp -n spywalker.conf.default /etc/default/spywalker.conf
fi

echo -e "\e[32mSetting execute permission on script files...\e[0m"
chmod u+x spywalker.sh
chmod u+x control_loop.sh
chmod u+x capture_hcxdump.sh
chmod u+x capture_kismet.sh
chmod u+x extract.sh
chmod u+x move.sh
chmod u+x online_status.sh

echo -e "\e[32mUpdate APT...\e[0m"
apt-get update
echo -e "\e[32mInstalling Dependencys...\e[0m"
#For Aircrack
apt-get install -y \
    tmux coreutils bc iw raspberrypi-kernel-headers \
    build-essential autoconf automake libtool pkg-config \
    libnl-3-dev libnl-genl-3-dev libssl-dev ethtool shtool \
    rfkill libcurl4-openssl-dev zlib1g-dev libpcap-dev \
    libsqlite3-dev libpcre3-dev libhwloc-dev libcmocka-dev \
    hostapd tcpdump screen    

#For GPS
apt-get install -y gpsd libncurses5-dev gpsd-clients python-gps ntp
echo "# gps ntp" >> "/etc/ntp.conf"
echo "server 127.127.28.0 minpoll 4" >> "/etc/ntp.conf"
echo "fudge  127.127.28.0 time1 0.183 refid NMEA" >> "/etc/ntp.conf"
echo "server 127.127.28.1 minpoll 4 prefer" >> "/etc/ntp.conf"
echo "fudge  127.127.28.1 refid PPS" >> "/etc/ntp.conf"
service ntp restart
dpkg-reconfigure gpsd

#For Kismet
apt-get install -y \
    build-essential git libmicrohttpd-dev pkg-config zlib1g-dev \
    libnl-3-dev libnl-genl-3-dev libcap-dev libpcap-dev libnm-dev \
    libdw-dev libsqlite3-dev libprotobuf-dev libprotobuf-c-dev \
    protobuf-compiler protobuf-c-compiler libsensors4-dev \
    libusb-1.0-0-dev python3 python3-setuptools python3-protobuf \
    python3-requests python3-numpy python3-serial python3-usb \
    python3-dev librtlsdr0 libubertooth-dev libbtbb-dev;

pip install paho-mqtt

echo -e "\e[32mDownloading and building Kismet...\e[0m"
cd /usr/local/src
git clone https://github.com/kismetwireless/kismet.git -b "kismet-2020-04-R3"
cd kismet/
./configure
make && make suidinstall
usermod -aG kismet $USER
cd ..

echo -e "\e[32mCloning and building Aircrack-ng...\e[0m"
git clone https://github.com/aircrack-ng/aircrack-ng.git
cd aircrack-ng/
autoreconf -i
./configure --with-experimental --with-ext-scripts
make && make check && make install
cd ..

echo -e "\e[32mCloning and building hcxtools...\e[0m"
git clone https://github.com/ZerBea/hcxtools.git
cd hcxtools/
make && make install
cd ..

echo -e "\e[32mCloning and building hcxdumptools...\e[0m"
git clone https://github.com/ZerBea/hcxdumptool.git
cd hcxdumptool/
make && make install
cd ..

echo -e "\e[32mCloning and building driver for rtl8188eus drivers...\e[0m"
git clone https://github.com/aircrack-ng/rtl8188eus.git
cd rtl8188eus
echo "blacklist r8188eu" >> "/etc/modprobe.d/realtek.conf"
make && make install
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