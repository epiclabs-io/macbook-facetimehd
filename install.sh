#!/bin/bash

# run this script in a empty folder or /tmp

sudo apt-get install linux-headers-`uname -r` git kmod libssl-dev checkinstall curl cpio

rm -rf "bcwc_pcie"

git clone https://github.com/patjak/bcwc_pcie

cd bcwc_pcie
rm -rf firmware

git clone https://github.com/patjak/facetimehd-firmware firmware

cd firmware

printf "Compiling firmware\n";
make
printf "done\n\n";

printf "Installing firmware\n";
sudo make install
printf "done\n\n";

cd ..

printf "Compiling driver\n";
make
printf "done\n\n";

printf "Installing driver\n";
sudo make install
printf "done\n\n";

sudo checkinstall

printf "Running depmod\n";
sudo depmod
printf "done\n\n";

printf "Running modprobe -r bdc_pci\n";
sudo modprobe -r bdc_pci
printf "done\n\n";

cd ..
printf "Copying calibration files..."
sudo cp *.dat /usr/lib/firmware/facetimehd/ 

printf "Loading driver\n";
sudo modprobe facetimehd

printf "Add facetimehd to /etc/modules"

sudo bash -c 'grep -qxF facetimehd /etc/modules || echo facetimehd >> /etc/modules'

printf "done\n\n";

