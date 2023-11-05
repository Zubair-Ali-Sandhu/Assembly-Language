org 0x100
jmp start
	multiplicand: dw 0xC8
	multiplier: db 0x32
	result : dw 0
multiply:
	push bp
	mov bp,sp
	push ax
	push dx
	push bx
	push cx
	xor ax,ax
	mov cx,8
	mov ax,[bp+6];cand
	mov bl,[bp+4];plier
	nextbit:
		shr bl,1
		jnc skip
		mov dl,al
		add byte[result],al
		mov dl,ah
		adc byte[result+1],dl
	skip:
		shl al,1
		rcl ah,1
		dec cx
		jnz nextbit
		pop cx
		pop bx
		pop dx
		pop ax
		pop bp
		ret 4
		
		
		
		
	
	
	
	
	start:
		mov ax,[multiplicand]
		push ax
		mov ax,[multiplier]
		push ax
		call multiply
		mov ax,0x4c00
		int 0x21
