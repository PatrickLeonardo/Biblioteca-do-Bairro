[BITS 16]
[ORG 7C00h]

call LoadSystem
jmp 0800h:0000h

LoadSystem:
	mov ah, 02h   ; read disk
	mov al, 1     ; number of sectors
	mov ch, 0     ; track zero
	mov cl, 2     ; sector to read
	mov dh, 0     ; head zero
	mov dl, 80h   ; first disk of order boot (pendrive)
	mov bx, 0800h ; address to store kernel
	mov es, bx
	mov bx, 0000h ; new value to bx (off-set 0000h)
				  ; :ES:BX = 0800h:0000h (800h * 65.535 bytes)
	int 13h       ; capture and read informations
ret

times 510 - ($-$$) db 0
dw 0xAA55
