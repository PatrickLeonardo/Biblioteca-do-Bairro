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
    
    sudo VBoxManage startvm Biblioteca-do-Bairro type=gui

    echo "Press enter to Poweroff vm..."
    read -rs

    sudo VBoxManage controlvm Biblioteca-do-Bairro poweroff
    echo "Ending! Press enter..." && read -rs
    clear
} || {
    read -rs
}
