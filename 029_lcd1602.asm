;Program for LCD interfacing to 8051 Microcontroller
;A "HELLO WORLD" PROGRAM

	DB0 EQU P0.0
	DB1 EQU P0.1
	DB2 EQU P0.2
	DB3 EQU P0.3
	DB4 EQU P0.4
	DB5 EQU P0.5
	DB6 EQU P0.6
	DB7 EQU P0.7
	
	EN  EQU P2.7
	RS  EQU P2.6
	RW  EQU P2.5

	BUS EQU P0

	
	org	00h
	sjmp	Main	;2 bytes instruction

Text:
	DB	'Hello, world! 1234567890'

Main:
	mov	A, #01H		;Clear screen
	acall	Function_set
	
	mov	A, #02H		;Return home
	acall	Function_set

	mov	A, #06H		;Entry mode set
	acall	Function_set

	mov	A, #0FH		;LCD ON, cursor ON, cursor blinking ON
	acall	Function_set
	
	mov	A, #38h		;Use 2 lines and 5x8 matrix
	acall	Function_set	

	mov	R2, #14
	mov	DPTR, #Text

	acall	Loop
	
	;mov	A, #82H		;Cursor line one , position 2
	;acall	Function_set
	;The "Set Cursor Position" instruction is 80h. 
	;add the address of the location where wish to position the cursor.
	;80h + 40h = C0h - the second line begins at address 40h
	mov	A, #0C0H		;Use 2 lines and 5x7 matrix
	acall	Function_set

	mov	R2, #10
	acall	Loop

	mov	A, #0CFH		;Use 2 lines and 5x7 matrix
	acall	Function_set

	sjmp	Halt


Loop:
	clr	A
	movc	A, @A+DPTR
	inc	DPTR
	acall	Write_char
	djnz	R2, Loop

	ret
	;sjmp	Halt

Done_LCD:
	clr	EN		;Start LCD command
	clr	RS		;It's an intruction
	setb	RW		;A read
	mov	BUS, #0FFh	;Set all pins to FF initially
	setb	EN		;Clock out instruction to LCD
	
	mov	A, BUS		;Read the return value
	;jb	ACC.7, $	;If bit 7 high, LCD still busy
	jb	ACC.7, Done_LCD
	clr	EN		
	clr	RW		;Turn off RW for future commands

	ret

Function_set:
	mov	P0, A
	clr	RS
	clr	RW
	setb	EN
	clr	EN
	acall	Done_lcd
	ret

Write_char:
	clr 	RW
	setb	RS
	mov	BUS, A
	setb	EN
	clr	EN
	
	acall	Done_LCD

	ret

Halt:
	sjmp	$

Endpoint:
	end

	