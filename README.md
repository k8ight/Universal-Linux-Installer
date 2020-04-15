# Debian-Cli-Installer
A sh script based debian or other supported linux live cd/usb installer 

#getting the file : wget https://git.io/uli.sh

#if fdisk not found error accurd on CLI use "su -" to access root 

#make the script executable using $ chmod +777 ./uli.sh

#then include it on ur live cd/dvd 's /usr/bin or on or /root /home dir

#required dependency parted (assuming others are included on kernel)

#call scirpt from shell ./uli.sh or ./path/to/uli.sh

then follow the instruction 

#it is advised to use /dev/sda or /dev/sdXXX on disk select

#This instaler install data on entire disk does not support partitioning  to support partioning modify uli.sh


#installer does not setup networks so you need to do it manually.
