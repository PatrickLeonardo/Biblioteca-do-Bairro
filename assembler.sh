#!/bin/bash
{
    clear
    echo ""

    echo "Assembling bootloader file..."	
    nasm -f bin bootloader.asm -o bootloader.bin
    read -rst 1; timeout=$?

    echo "Assembling kernel file..."
    nasm -f bin kernel.asm -o kernel.bin
    read -rst 1; timeout=$?

    echo "Assembling image file..."
    dd if=bootloader.bin of=./OS.img seek=0 bs=512
    dd if=kernel.bin     of=./OS.img seek=1 bs=512

    echo "Mounting Image..."
    sudo dd if=./OS.img of=/dev/sda bs=10M oflag=direct && sync
    echo "Done!"

    echo "Assembling Virtual Machine"
    sudo VBoxManage createvm --name "Biblioteca-do-Bairro" --ostype Oracle_64 --register
    sudo VBoxManage storagectl "Biblioteca-do-Bairro" --name "SATA Controller" --add sata --controller IntelAhci
    sudo VBoxManage internalcommands createrawvmdk -filename "./usb.vmdk" -rawdisk /dev/sda
    sudo VBoxManage storageattach "Biblioteca-do-Bairro" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium './usb.vmdk'
    sudo VBoxManage startvm "Biblioteca-do-Bairro" type=gui

    echo "Press enter to Poweroff vm..."
    read -rs

    sudo VBoxManage controlvm "Biblioteca-do-Bairro" poweroff
    sleep 3
    sudo VBoxManage unregistervm "Biblioteca-do-Bairro" --delete-all
    sudo rm -r ./*.bin
    echo "Ending! Press enter..." && read -rs
    clear
} || {
    read -rs
}
