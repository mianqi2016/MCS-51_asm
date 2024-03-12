;Multiplication
;8*8 single DEC number multiplication table

	org	00h
	sjmp	Main

	;interrupt vectors stored till 0033h
	org	0035h
Multiplier:
	DB 1, 2, 3, 4, 5, 6, 7, 8	

	org	0040h
Main:
	;mov	R1, #50h	;row - 8 numbers storage start here - 0050h-0057h
	;mov	R0, #58H	;col - 8 numbers storage start here - 0058h,60h,68h,70h,78h,80h,88h,90h
	;mov	R3, #8	;irerate timers for initialization
	;clr	A
	;mov	R2, A	;set R2 initial value :00h
	;inc	R2

Initialize:
	;mov	A, R2
	;mov	@R1, A	;store back 0-10 Dec into 0050h-0059h
	;inc	R1	;using R1 in register addressing
	
	;mov	A, R2
	;mov	@R0, A

	;clr	A
	;mov	A, #08
	;add	A, R0
	;mov	R0, A
	
	;inc	R2	;using R2 generating 0-7 Dec

	;djnz	R3, INITIA	;iterate 9 times

Multiplication:
	mov	R7, #08	;iterates 8 times for 8 rows
	mov	R6, #00	;start location in DB for each line
	mov	R5, #00	;index of DB
	mov	R4, #00	;value in B register

	mov	R1, #30h	;skip bit_addressable fields
				;add 8 for newline
	mov	R0, #30h	;active position for each line

Print_row:
	mov	DPTR, #Multiplier	;label of DB is 16-bit value	
	
	clr	A
	mov	A, R6
	movc	A, @A+DPTR
	mov	R4, A
	mov	B, R4

	mov	R5, #00

Loop:
	clr	A
	add	A, R6
	add	A, R5

	movc	A, @A+DPTR

	mov	B, R4	;since B store high-order byte of multiply result
		
	mul	AB
	mov	@R0, A

	inc	R0
	inc	R5

	mov	80h, R7	;store iterater into a separated location - 80h
	mov	A, R5
	cjne	A, 80h, Loop	;compare R5 with R7 for row end test

Newline:
	clr	A	;start a newline
	mov	A, #08h
	add	A, R1
	mov	R1, A

	inc	R6
	
	add	A, R6
	mov	R0, A

	djnz	R7, Print_row
Stop:
	end

	