#!/bin/bash
export PS1="\e[1;32m[\u@\h \W]\$ \e[m "
echo "deb http://deb.debian.org/debian stable main" >> /etc/apt/sources.list
apt update
apt install -y fdisk parted 
mkdir /mnt/idrive
mkdir /mnt/ddrive
mount /dev/loop0 /mnt/idrive
fdisk -l



echo "SELECT DRIVE TO CREATE OR EDIT PARTITION (like /dev/sdX  & do not select /dev/loop*) all data will be destroyed:"

read diskname

umount -f $diskname"1"
umount -f $diskname
cfdisk $diskname
fdisk -l
echo "SELECT Partition to COPY OS DATA:"
read pname


mkfs.ext4 -L debian $pname
parted $diskname set 1 boot on
mount  $pname /mnt/ddrive 
mount -f $pname  /mnt/ddrive   

echo "Copy filesystem to target ? [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
        echo "Copying File system"
mount  $pname /mnt/ddrive 
cp -av /mnt/idrive/* /mnt/ddrive

echo "Copying File system Done!"
else
        echo "Abort"
exit
fi


blkid -s UUID -o value $diskname"1" > ui.dat
value="$(cat ./ui.dat)"
echo "UUID="$value"  /           ext4   noatime 0 1"  > /mnt/ddrive/etc/fstab
echo "Setting fstab Done!"
echo "deb http://deb.debian.org/debian/ buster main contrib non-free" > /mnt/ddrive/etc/apt/sources.list
echo "deb http://deb.debian.org/debian/ bullseye main contrib non-free" >> /mnt/ddrive/etc/apt/sources.list
echo "Setting sources Done!"
echo "nameserver 8.8.8.8" > /mnt/ddrive/etc/resolv.conf
echo $'[Match]\nName=en*\n[Network]\nDHCP=yes'>/mnt/ddrive/etc/systemd/network/dhcp.network
echo "Setting apt Sources Done!"
cp /etc/locale.gen /mnt/ddrive/etc/locale.gen
cp /etc/default/locale /mnt/ddrive/etc/default/locale
mount --bind --make-rslave /dev /mnt/ddrive/dev
mount --bind --make-rslave /proc /mnt/ddrive/proc
mount --bind --make-rslave /sys /mnt/ddrive/sys
chroot /mnt/ddrive /bin/bash -c "locale-gen --purge en_US.UTF-8"
chroot /mnt/ddrive /bin/bash -c "update-initramfs -u"
chroot /mnt/ddrive /bin/bash -c "apt update"
chroot /mnt/ddrive /bin/bash -c "apt install ntfs-3g -y"
chroot /mnt/ddrive /bin/bash -c "apt install grub2 -y"
chroot /mnt/ddrive /bin/bash -c "grub-install $diskname"
echo "set root password [y/n]:"
read inputp
if [[ $inputp == "Y" || $inputp == "y" ]]; then
   chroot /mnt/ddrive /bin/bash -c "passwd root"

else
        echo "Root Password Default to user root password toor"
fi
echo "Create non-admin User:[Y/n]"
read inputu
if [[ $inputu == "Y" || $inputu == "y" ]]; then
 echo "Enter username:"
 read usn
   chroot /mnt/ddrive /bin/bash -c "adduser $usn"
   chroot /mnt/ddrive /bin/bash -c "usermod -G sudo,netdev $usn"
   
else
        echo "No Local non-admin user has created!!"
fi
echo "installation done reboot to continue using your new intall root password toor if not set !!"
