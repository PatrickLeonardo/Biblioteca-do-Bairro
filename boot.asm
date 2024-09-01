[BITS 16]    ; archtecture system 
[ORG 0x7C00] ; organize with 0x7C00 (MBR) to bios

call HelloWorld
call JumpLine

call PointerString
call PrintString

call PointerBuffer
call ReadString
call PointerStringBuf
call PrintString
jmp $

HelloWorld:
	mov ah, 0eh ; AH + AL = AX
	mov al, 48h ; H
	int 10h
	mov al, 65h ; e
	int 10h
	mov al, 6ch ; l
	int 10h
	mov al, 6ch ; l
	int 10h
	mov al, 6fh ; o
	int 10h
	mov al, 20h ; space
	int 10h
	mov al, 57h ; W 
	int 10h
	mov al, 6fh ; o
	int 10h
	mov al, 72h ; r
	int 10h
	mov al, 6ch ; l
	int 10h
	mov al, 64h ; d
	int 10h
	mov al, 21h ; !
	int 10h
	ret

JumpLine:
	mov ah, 0eh
	mov al, 0ah
	int 10h
	mov al, 0dh 
	int 10h
	ret

PointerString:
	mov si, hello
	ret

PointerBuffer:
	mov di, buffer
	ret

PointerStringBuf:
	mov si, buffer
	ret

PrintString:
	mov ah, 0eh
	mov al, [si]
	print:
		int 10h
		inc si
		mov al, [si]
		cmp al, 0
		jne print
	ret

ReadString:
	mov ah, 00h
	int 16h
	mov ah, 0eh
	int 10h
	mov [di], al
	inc di
	cmp al, 0dh
	jne ReadString
	mov ah, 0eh
	mov al, 0ah
	int 10h
ret

hello db "Hello World!", 13, 10, 0
buffer times 20 db 0 ; length = 20 (0 20 times)
 
times 510 - ($-$$) db 0 ; bootloader 512 bytes (510 + signature)

dw 0xAA55               ; load default OS, if not loaded
