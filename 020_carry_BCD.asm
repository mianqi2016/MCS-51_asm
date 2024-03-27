;demo for Carry and BCD arithmatic

	org	00h
	sjmp	Setup	;2 bytes instructions

	org	10h
Array:	DB	12h, 23h, 34h, 45h, 56h, 67h, 78h, 89h

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
	da	A
	jnc	Next
	inc	R7
Next:
	inc	R0
	djnz	R2, Run

	end

	