#!/bin/bash
mkdir /mnt/idrive
mkdir /mnt/ddrive
mount /dev/loop0 /mnt/idrive
fdisk -l



echo "SELECT DRIVE TO INSTALL (like /dev/sdX  & do not select /dev/loop*) all data will be destroyed:"

read diskname

umount -f $diskname"1"
umount -f $diskname



echo "Select partition scheme GPT or msdos (GPT is to be used for ufi & newer os| for MBR scheme on older os and windows  use msdos):"

read psc

parted $diskname mklabel $psc 
parted -a opt $diskname mkpart primary ext4 0% 100%
mkfs.ext4 -L debian $diskname"1"
parted $diskname set 1 boot on
mount $diskname"1" /mnt/ddrive 

echo "Copy filesystem to target ? [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
        echo "Copying File system"

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
echo "deb http://deb.debian.org/debian/ stable main contrib non-free" > /mnt/ddrive/etc/apt/sources.list
echo "Setting sources Done!"
echo "nameserver 8.8.8.8" > /mnt/ddrive/etc/resolv.conf
echo "Setting apt Sources Done!"
cp /etc/locale.gen /mnt/ddrive/etc/locale.gen
cp /etc/default/locale /mnt/ddrive/etc/default/locale
mount --bind --make-rslave /dev /mnt/ddrive/dev
mount --bind --make-rslave /proc /mnt/ddrive/proc
mount --bind --make-rslave /sys /mnt/ddrive/sys
chroot /mnt/ddrive /bin/bash -c "locale-gen --purge en_US.UTF-8"
chroot /mnt/ddrive /bin/bash -c "apt update"
chroot /mnt/ddrive /bin/bash -c "apt install grub2 -y"
chroot /mnt/ddrive /bin/bash -c "grub-install $diskname"
chroot /mnt/ddrive /bin/bash -c "update-initramfs -u"
echo "set root password [y/n]:"
read inputp
if [[ $inputp == "Y" || $inputp == "y" ]]; then
   chroot /mnt/ddrive /bin/bash -c "passwd root"

else
        echo "Root Password Default to user root password toor"
fi
echo "installation done reboot to continue using your new intall root password toor if not set !!"