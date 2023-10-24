org 0x0100
jmp start
clrscr:
push es 
push cx
push di
push ax
mov ax,0xb800
mov es,ax		; point es to video base
mov di,0 		; point di to top left column
mov ax,0x0700 		; space char in normal attribute
mov cx,2000   		; number of screen locations
cld         		; auto increment mode
rep stosw   		; clear the whole screen
pop ax
pop di
pop cx
pop es
ret
 
printscr:
push bp
mov bp,sp
push ax
push es
push di
push bx
mov ax,0xb800
mov es,ax
mov ax,[bp+6]        ;load y position
mov cx,30
mul cx
mov bx,ax
mov ax,[bp+4]        ;load x position
add ax,bx
mov cx,3
mul cx               ;final location
mov di,ax            ; pointing di to desired loaction
mov ax,[bp+8]
mov cx,9             ; for width
mov bx,9             ;for lenght
loop1:
mov [es:di],ax       ;print * on video memory from ax
add di,2             ; moving di to next location
dec cx               ; cx-1
jnz loop1  	     ; if cx is not zero jmp to loop1
add di,142 	     ; moving to next line 9*2=18 ->160-18=142
     
mov cx,9    	     ; again start the cx from 0 to print nine * in the new line
dec bx      	     ; bx-1
jnz loop1   	     ; if we have not printed 9 lines of * then again repet the loop
pop bx
pop di
pop es
pop ax
pop bp
ret 6


start:
call clrscr 		; to clear the screen
mov ax,0x012a 		; moving * to ax with blue foreground
push ax       		 ;moving * to stack
mov ax,20      
push ax 		; push y position
mov ax,10
push ax 		; push x position
call printscr 		; calling printscr to print * pattern
mov ax,0x4c00
int 0x21