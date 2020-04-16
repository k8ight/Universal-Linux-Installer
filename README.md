# Universal-Linux-Installer
A sh script based debian or other supported linux live cd/usb installer 

# getting the file : wget https://git.io/uli.sh

# if fdisk not found error accurd on CLI use "su -" to access root 

# make the script executable using $ chmod +777 ./uli.sh

# then include it on ur live cd/dvd 's /usr/bin or on or /root /home dir

# required dependency parted (assuming others are included on kernel)

# call scirpt from shell ./uli.sh or ./path/to/uli.sh

then follow the instruction 

# it is advised to use /dev/sda or /dev/sdXXX on disk select

# This installer install data on entire disk or Selected SIZE in GB


# installer does  setup networks under DHCP .
# IF local repo not set manually on the Installer, it requires internet connection
