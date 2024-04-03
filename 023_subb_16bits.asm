;demo for subb with borrow
;16-bit subb
;reference: https://what-when-how.com/8051-microcontroller/arithmetic-instructions/

;The SUBB instruction always subtracts the second value in the instruction from the first, less any carry. 
;While there are two versions of the ADD instruction (ADD and ADDC), one of which ignores the carry bit, 
;there is no such distinction with the SUBB instruction. This means before you perform the first subtraction, 
;you must always be sure to clear the carry bit. Otherwise, if the carry bit happens to be set you'll end up subtracting it from your first column value -- which would be incorrect.

;In many microprocessors there are two different instructions for subtraction: SUB and SUBB (subtract with borrow).
;In 8051, there is only SUBB.
;To make SUB out of SUBB, one have to make CY = 0 prior to the execution of the instruction. 

;In subtraction, the 8051 microprocessors (indeed, all modern CPUs) use the 2's complement method. 
;Although every CPU contains adder circuitry, it would be too cumbersome (and take too many transistors) to design separate subtracter circuitry.
;For this reason, the 8051 uses adder circuitry to perform the subtraction command.

;Assuming that the 8051 is executing a simple subtract instruction and that CY = 0 prior to the execution of the instruction,
;one can summarize the steps of the hardware of the CPU in executing the SUBB instruction for unsigned numbers, as follows:
;1.Take the 2's complement of the subtrahend (source operand).
;2.Add it to the minuend (A).
;3.Invert the carry.

	org	00h
	sjmp	Setup	;2 bytes instruction

Setup:
	clr	A	;1 byte instruction
	mov	R7, A	;1 byte instruction
	mov	R6, A
	mov	R5, A
	mov	R4, A
	mov	R3, A
	mov	R2, A
	sjmp	Main	;2 bytes instruction

	org	11h
Main:
	mov	R6, #34h	;Load the low byte of the 1st value into R6
	mov	R7, #12h	;Load the high byte of the 1st value into R7

	mov	R4, #78h	;Load the low byte of the 2nd value into R4
	mov	R5, #56h	;Load the high byte of the 2nd value into R5

	acall	Subb16bits	;Call the 16-bit subtraction routine

Subb16bits:
	;Step 1 of the process
	mov	A, R6	;Move the first low-byte into the accumulator
	clr	cy	;Always clear carry before first subtraction
	subb	A, R4	;Subtract the second low-byte from the accumulator
	mov	R2, A	;Move answer to the low-byte of the result

	;Step 2 of the process
	mov	A, R7	;Move the first high-byte into the accumulator
	subb	A, R5	;Subtract the second high-byte from the accumulator
	mov	R3, A	;Move answer to the high-byte of the result
	
	mov	A, R2
	cpl	A
	clr	cy
	add	A, #01h	;inc A would not affect CY flag
	mov	R2, A

	mov	A, R3
	cpl	A
	mov	R3, A

	jnc	Return
	inc	R3	;Attention: inc Rn would not affect CY flag, so if
	;there is a carry, it would be lost rather than be record.
	
Return:
	;Return - answer now resides in R2, and R3.
	ret

	end

	
