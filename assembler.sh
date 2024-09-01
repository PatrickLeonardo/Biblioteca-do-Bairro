#!/bin/bash
{
	clear
	echo "Assembling bootloader file..."	
	nasm -f bin bootloader.asm -l bootloader.bin
	read -rst 1; timeout=$?

	echo "Assembling kernel file..."
	nasm -f bin kernel.asm -l kernel.bin
	read -rst 1; timeout=$?

	dd if=bootloader.bin of=OS.img bs=512 seek=1 conv=notrunc
	dd if=kernel.bin of=OS.img bs=512 seek=2 conv=notrunc
	echo "Done! Press enter..."
	read -rs
	clear
} || {
	read -rs
}
