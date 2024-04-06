;demo for div
;demo for Division of unsigned numbers
;In the division of unsigned numbers, the 8051 supports byte over byte only.
;The syntax is as follows: 
;div AB	;devide A by B
;When dividing a byte by a byte, the numerator must be in register A and the denominator must be in B. 
;After the DIV instruction is performed, the quotient is in A and the remainder is in B.

;numerator - the number above the line in a common fraction showing how many of the parts indicated by the denominator are taken, for example, 2 in 2/3.
;denominator - A denominator is the bottom part of a fraction that indicates the number of equal parts in which the whole thing is divided.

;Note:
;This instruction always makes CY = 0 and OV = 0 if the denominator is not 0.
;If the denominator is 0 (B = 0), OV = 1 indicates an error, and CY = 0.
;The standard practice in all microprocessors when dividing a number by 0 is to indicate in some way 
;the invalid result of infinity. In the 8051, the OV flag is set to 1.

	org	00h
	sjmp	Setup	;2 bytes instruction

Setup:
	clr	A
	mov	B, A

Divide:
	mov	A, #0CDh
	mov	B, #0ABh
	div	AB

	mov	R7, B
	mov	R6, A

	;convert hex data to decimal
	clr	A
	mov	B, A

	mov	A, #0EAh	;decimal - 234
	mov	B, #10		;decimal - 10
	div	AB	;Quotient in A, Remainder - B
	mov	R5, B	;low digit
	mov	B, #10
	div	AB
	mov	R6, B	;middle digit
	mov	R7, A	;high digit

	;convert decimal to ASCII
	;2 - 32h
	;3 - 33h
	;4 - 34h
	mov	A,  #30h	;0011 0000B - 48Dec
	orl	A, R7
	mov	R4, A

	mov	A,  #30h
	orl	A, R6
	mov	R3, A
	
	mov	A,  #30h
	orl	A, R5
	mov	R2, A
	
	end

	

	