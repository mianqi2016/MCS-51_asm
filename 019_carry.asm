;demo for add with concerns to carry flag
;2 8-bit register store 16-bit value - 0-65535DEC
;P = 0 because the number of 1s is zero (an even number).


	org	00h
	sjmp	Setup	;2 bytes instructions

	org	10h
Array:	DB	7Ch, 10001011b, 9Eh, 3Fh, 6Ah, 99h, 45h, 0FFh	;Syntax error: Invalid numeric value: 8b (should be binary number)

	org	20h
Setup:
	mov	R0, #31h	;location start in memory
	mov	R2, #8	;location counter
	mov	R7, #00h	;accumulate carry
	mov	DPTR, #Array

Data_load:
	clr	A
	movc	A, @A+DPTR
	mov	@R0, A
	inc	DPTR
	inc	R0
	djnz	R2, Data_load

Sum:
	mov	R0, #31h
	mov	R2, #8
	mov	R7, #00h
	clr	A

Run:
	add	A, @R0
	jnc	Next
	inc	R7
Next:
	inc	R0
	djnz	R2, Run

	end

	
	