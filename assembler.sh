#!/bin/bash
{
	clear
	echo "Assembling bootloader file..."	
	nasm -f bin bootloader.asm -o bootloader.bin
	read -rst 1; timeout=$?

	echo "Assembling kernel file..."
	nasm -f bin kernel.asm -o kernel.bin
	read -rst 1; timeout=$?

	echo "Done! Press enter..."
	read -rs
	clear
} || {
	read -rs
}
