;demo for multiplying of 2 16-bit number
;demo for mul with 16-bit result


	org	00h
	sjmp	Setup	;2 bytes instruction

Setup:
	;demo for mul with 16-bit result
	;The 8051 supports byte-by-byte multiplication only. 
	;In multiplying or dividing two numbers in the 8051, the use of registers A and B is required since 
	;the multiplication and division instructions work only with these two registers. 
	;After multiplication, the result is in A and B registers; the lower byte is in A, and the upper byte is in B.

	clr	A
	mov	B, A

	mov	A, #0ABh
	mov	B, #0CDh
	mul	AB

	;demo for multiplying of 2 16-bit number start below
	;The first number will be contained in R7 and R6, the second number will be held in R5 and R4.
	;R7 and R5 contain high byte, R6 and R4 contain low byte
	;The result of multiplication will end up in R3, R2, R1 and R0.
	;R3-R2 contain high byte, R1-R0 contain low byte
	;As 8-bits per register, these 4 registers give 32 bits to handle the largest possible multiplication.
	
	;The process will be the following:
	;Multiply R6 by R4, leaving the 16-bit result in R1 and R0.
	;Multiply R7 by R4, adding the 16-bit result to R2 and R1.
	;Multiply R6 by R5, adding the 16-bit result to R2 and R1.
	;Multiply R7 by R5, adding the 16-bit result to R3 and R2.
	
	clr	A
	mov	B, A

	mov	R7, A
	mov	R6, A
	mov	R5, A
	mov	R4, A
	mov	R3, A
	mov	R2, A
	mov	R1, A
	mov	R0, A

	;Load the first value into R7 and R6
	mov	R7, #12h
	mov	R6, #34h
	;Load the second value into R5 and R4
	mov	R5, #0ABh
	mov	R4, #0CDh

	;Call the 16-bit subtraction routine
	acall	Multiply16bits

	sjmp	Stop
	

Multiply16bits:
;Step 1. Multiply R6 by R4, leaving the 16-bit result in R1 and R0.
	clr	A
	mov	B, A
	
	mov	A, R6
	mov	B, R4
	mul	AB   	;Multiply the two values
	mov	R1, B 	;Move B (the high-byte) into R1
	mov	R0, A 	;Move A (the low-byte) into R0

;Step 2. Multiply R7 by R4, adding the 16-bit result to R2 and R1.
	mov	A, R7   ;Move R7 into the Accumulator
	mov	B, R4   ;Move R4 into B register
	mul	AB	;Multiply the two values
	add	A, R1   ;Add the low-byte of result into the value already in R1
	mov	R1, A	;update R1
	mov	A, B	;Move the high-byte of result into the accumulator
	mov	R2, A	;Move the high-byte of result into R2
	
	mov	A, #00h	;Load the accumulator with zero
	addc	A, #00h	;Adding carry from former step
	add	A, R2	;Add zero (plus the carry, if any)
	mov	R2, A	;Move the resulting value back into R2
	
	mov	A, #00h	;Adding carry, if any.
	addc	A, #00h	;Adding carry from former step(if any)
	add	A, R3
	mov	R3, A	;Move the carry (if any) into R3.
	
;Step 3. Multiply R6 by R5, adding the 16-bit result to R2 and R1.
	mov	A, R6	;Move R6 into the Accumulator
	mov	B, R5	;Move R5 into B register
	mul	AB	;Multiply the two values
	add	A, R1	;Add the low-byte into the current value in R1 (Carry maybe)
	mov	R1, A	;Move the result back into R1

	mov	A,B     ;Move the high-byte into the accumulator
	addc	A, R2	;Add the current value of R2 (plus any carry)
	mov	R2, A	;Move the resulting value back into R2.

	mov	A, #00h	;Adding carry, if any.
	addc	A, #00h	
	add	A, R3
	mov	R3, A	;Move the carry (if any) into R3.

;Step 4. Multiply R7 by R5, adding the 16-bit result to R3 and R2.
	mov	A, R7	;Move R7 into the Accumulator
	mov	B, R5	;Move R5 into B register
	mul	AB	;Multiply the two values
	add	A, R2	;Add the low-byte into the current value in R2 (Carry maybe)
	mov	R2, A	;Move the result back into R2

	mov	A,B     ;Move the high-byte into the accumulator
	addc	A, R3	;Add the current value of R3 (plus any carry)
	mov	R3, A	;Move the resulting value back into R3.

	ret

Stop:
	end


