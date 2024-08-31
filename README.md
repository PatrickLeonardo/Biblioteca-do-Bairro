# Biblioteca-do-Bairro

The Neighborhood Library is an Operating System with the proposal of private peer-to-peer communication. Following the idea of a non-rastravel and totally secure communication

<hr>

Create the disk image (512 bytes)
```
dd if=boot.bin of=boot.img bs=512
```

Create binary file
```
nasm -f bin boot.asm -f boot.bin
```
