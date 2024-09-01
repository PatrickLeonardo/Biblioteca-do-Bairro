[BITS 16]
[ORG 0000h]

jmp OSMain

BackWidth db 0
BackHeight db 0
Pagination db 0
Welcome db "Biblioteca do Bairro!", 0


OSMain:
	call ConfigSegment
	call ConfigStack
	call TEXT.SetVideoMode
	jmp ShowString

ShowString:
	mov dh, 3 ; row
	mov dl, 2 ; column
	call MoveCursor ; move to (3, 2)
	mov si, Welcome
	call PrintString
	jmp END

ConfigSegment:    ; (0800h)
	mov ax, es
	mov ds, ax
ret

ConfigStack:
	mov ax, 7D00h
	mov ss, ax    ; 7D00h:03FEh
	mov sp, 03FEh
ret

TEXT.SetVideoMode:
	mov ah, 00h
	mov al, 03h   ; text mode (03h)
	int 10h
	mov BYTE[BackWidth], 80
	mov BYTE[BackHeight], 20
ret

PrintString:
	mov ah, 09h
	mov bh, [Pagination] ; video pagination
	mov bl, 40           ; background color
	mov cx, 1            ; number of character repeat
	mov al, [si]
	print:
		int 10h
		inc si
		call MoveCursor
		mov ah, 09h
		mov al, [si]
		cmp al, 0
		jne print        ; jump not equal
ret

MoveCursor:
	mov ah, 02h ; move cursor
	mov bh, [Pagination]
	inc dl
	int 10h
ret

END:
	jmp $