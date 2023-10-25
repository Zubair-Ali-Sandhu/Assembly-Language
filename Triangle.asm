org 0x0100        ; Set the origin point of the program to 0x0100.
jmp start         ; Jump to the "start" label to begin program execution.

clrscr:           ; This is a label marking the beginning of the "clrscr" subroutine.
push es           ; Push the ES register onto the stack.
push cx           ; Push the CX register onto the stack.
push di           ; Push the DI register onto the stack.
push ax           ; Push the AX register onto the stack.
mov ax, 0xb800    ; Load the address of the video memory into AX.
mov es, ax        ; Set the ES register to point to the video memory.
mov di, 0         ; Set DI (destination index) to 0, pointing to the top-left corner of the screen.
mov ax, 0x0700    ; Set AX to a space character with a normal attribute.
mov cx, 2000      ; Set CX to 2000, the number of screen locations.
cld              ; Set the direction flag to auto-increment mode.
rep stosw         ; Use REP STOSW instruction to clear the whole screen with spaces.
pop ax            ; Restore the AX register.
pop di            ; Restore the DI register.
pop cx            ; Restore the CX register.
pop es            ; Restore the ES register.
ret              ; Return from the subroutine.

printscr:         ; This is a label marking the beginning of the "printscr" subroutine.
push bp           ; Push the base pointer onto the stack to set up a stack frame.
mov bp, sp        ; Set the base pointer to the current stack pointer value.
push ax           ; Push the AX register onto the stack.
push es           ; Push the ES register onto the stack.
push di           ; Push the DI register onto the stack.
push bx           ; Push the BX register onto the stack.
push si
mov ax, 0xb800    ; Load the address of the video memory into AX.
mov es, ax        ; Set the ES register to point to the video memory.
mov ax, [bp+6]    ; Load the y position from the stack.
mov cx, 30        ; Set CX to 30.
mul cx            ; Multiply AX by CX.
mov bx, ax        ; Copy the result to BX.
mov ax, [bp+4]    ; Load the x position from the stack.
add ax, bx        ; Add BX to AX.
mov cx, 3         ; Set CX to 3.
mul cx            ; Multiply AX by CX to calculate the final location.
mov di, ax        ; Set DI to point to the desired location.
mov ax, [bp+8]    ; Load the character to be printed from the stack.
mov cx, 0         ; Set CX for width.
mov bx, 1         ; Set BX for length.
loop1:            ; Start of a loop.
mov [es:di], ax   ; Print the character (AX) to the video memory location pointed to by DI.
add di, 2         ; Move DI to the next location.
inc cx            ; Increment CX.
cmp cx, bx        ; Compare CX with BX (check if we've printed the desired number of characters).
jnz loop1         ; Jump back to loop1 if CX is not zero.
mov si, bx        ; Copy BX to SI.
shl si, 1         ; Shift SI left by 1 (multiply by 2).
sub di, si        ; Move DI to the next line (based on the pattern).
inc bx            ; Increment BX (for the next line).
add di, 160       ; Move DI to the start of the next line (160 characters wide).
mov cx, 1         ; Set CX to 1.
cmp bx, 9         ; Compare BX with 9.
jnz loop1         ; Jump back to loop1 if we haven't printed 9 lines yet.
pop si
pop bx            ; Restore the BX register.
pop di            ; Restore the DI register.
pop es            ; Restore the ES register.
pop ax            ; Restore the AX register.
pop bp            ; Restore the base pointer.
ret 6             ; Return from the subroutine, freeing the parameters from the stack.

start:            ; This is the start of the main program labeled "start."
call clrscr       ; Call the "clrscr" subroutine to clear the screen.
mov ax, 0x012a    ; Load the value 0x012a (an asterisk with a blue foreground) into AX.
push ax           ; Push the value in AX onto the stack.
mov ax, 20        ; Push the Y position (20) onto the stack.
push ax
mov ax, 10        ; Push the X position (10) onto the stack.
push ax
call printscr     ; Call the "printscr" subroutine to print the asterisk triangle  pattern.
mov ax, 0x4c00    ; Set up an exit function code in AH (4c) and terminate the program (INT 0x21).
int 0x21
