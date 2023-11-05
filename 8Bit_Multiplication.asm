org 0x100
jmp start
multiplicand: db 13
multiplier: db 5
result: db 0
multiply:
	push bp
	mov bp,sp
	push ax
	push cx
	push bx
	xor ax,ax
	mov cl,4
	mov bl,[bp+6];plier
	mov al,[bp+4] ;cand
	mult:
		shr bl,1
		jnc skip
		add [result],al
	skip:
		shl al,1
		dec cl
		jnz mult
		
		pop bx
		pop cx
		pop ax
		pop bp
		ret
	
	
start:
	mov ax,[multiplier]
	push ax
	mov ax,[multiplicand]
	push ax
	call multiply
	mov ax,0x4c00
	int 0x21
