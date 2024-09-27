[BITS 16]    ; archtecture system 
[ORG 0x7C00] ; organize with 0x7C00 (MBR) to bios

jmp OSMain

BackWidth db 0
BackHeight db 0
Pagination db 0
Repl db "> ", 0

OSMain:
	call ConfigSegment
	call ConfigStack
	call TEXT.SetVideoMode
	call BackColor
	call ShowString
	call MainLooping

MainLooping:
	call PointerBuffer
	call ReadString
	call PointerStringBuf
	call PrintString
	call MainLooping

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

BackColor:
	mov ah, 06h        ; clear screen (06h)
	mov al, 0
	mov bh, 0000_1111b ; text color
	mov ch, 0
	mov cl, 0
	mov dh, 60         ; number of lines scrooleds
	mov dl, 80         ; collumns
	int 10h
ret

ShowString:
	mov dh, 20 ; row
	mov dl, 0 ; column
	call MoveCursor ; move to (3, 2)
	mov si, Repl
	call PrintRepl
	mov ah, 00
	;int 16h ; wait for press key
	;jmp END

PrintRepl:
	mov ah, 09h
	mov bh, [Pagination] ; video pagination
	mov bl, 0000_1111b   ; background color
	mov cx, 1            ; number of character repeat
	mov ah, 0eh
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

PointerBuffer:
	mov di, buffer
	ret

PointerStringBuf:
	mov si, buffer
	ret

PrintString:
	mov ah, 0eh
	mov al, [si]
	log:
		int 10h
		inc si
		mov al, [si]
		cmp al, 0
		jne log
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

buffer times 20 db 0 ; length = 20 (0 20 times)

END:
	jmp $
	;int 19h ; restart pc
