;demo for addc
;ADDC and addition of 16-bit numbers
;When adding two 16-bit data operands, it is needed to be concerned with the propagation of a carry from the lower byte to the higher byte.
;The instruction ADDC (add with carry) is used on such occasions. 

	org	00h
	sjmp	Setup	;2 bytes instructions

	org	10h
Array:	DB	7Ah, 4Dh, 3Ch, 5Fh, 1Ah, 6Bh, 2Ch, 8Eh, 9Bh, 5Dh, 4Fh, 4Ch, 7Bh, 6Dh, 2Dh, 9Fh
;former are 8 16-bit numbers - low byte right
;Directive DW can take only one argument

	org	20h

Setup:
	mov	R2, #7	;index of 8 16-bit number
	clr	cy	;make PSW.CY=0

	clr	A	;A memory one of the 2 bytes for one 16-bit number loaded from DB
	mov	B, A	;B memory the other byte of the 2 bytes for one 16-bit number loaded from DB
	mov	R3, A	;temperarily store the third byte
	mov	R5, A	;store carry out of bit_15
	
	mov	R7, A	;R7 store the high byte of the sum
	mov	R6, A	;R6 store the low byte of the sum

	clr	A
	mov	DPTR, #Array
	movc 	A, @A+DPTR
	mov 	R7, A		;load HIGH byte into R7

	clr	A
	inc 	DPTR
	movc 	A, @A+DPTR
	mov	R6, A 		;load low byte into R6
	

Sum:
	clr	A
	inc 	DPTR
	movc 	A, @A+DPTR
	mov 	R3, A

	clr	A
	inc 	DPTR	;advance DPTR 2 bytes forward
	movc 	A, @A+DPTR
	mov	B, A 

	mov	A, R6
	add	A, B	;add 2 low bytes of the 1st 16-bit number
	mov	R6, A	;memory the sum of 2 low bytes into R6
	
	clr	A
	mov	A, R7
	addc	A, R3	;add 2 high bytes of the 1st 16-bit number
	mov	R7, A

	jnc	Next
	inc	R5
	
Next:
	djnz	R2, Sum

	end
 