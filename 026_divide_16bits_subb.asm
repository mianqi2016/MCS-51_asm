;demo for 16-bit Division
;dividend - a number to be divided by another number.
;divisor - a number by which another number is to be divided.

;the dividend stored in R7-R6, the divisor stored in R5-R4, result stored in R3-R2
;both arranged in high-low byte order

;this program based on example codes here:
;http://www.8052mcu.com/div16 - 16-bit Division Written by Jorg Rockstroh
;updated in 3 aspects:
;adjustment of register pair sequence - high byte with bigger index number
;fixed some errors in comments
;demo oprands changed to be more normally 

	org	00h
	sjmp	Setup	;2-byte instruction

Setup:
	clr	cy	;Clear carry initially
	
	clr	A
	mov	B, A	;Clear B since B will count the number of left-shifted bits
	mov	R3, A	;high-byte of temporary result
	mov	R2, A	;low-byte of temporary result

	mov	R7, #0ABh	;dividend - ABCDh
	mov	R6, #0CDh

	mov	R5, #12h	;divisor - 1234h
	mov	R4, #34h

Step_1:
;Shift the divisor left high byte followed by low byte one bit by one bit with carry
	inc	B;Increment counter for each left shift
	
	mov	A, R4	;Move divisor low byte into accumulator
	rlc	A	;Shift low-byte left, rotate through carry for buffering each highest bit into high-byte
	mov	R4, A	;Save the updated divisor low-byte
	
	mov	A, R5	;Move divisor high byte into accumulator
	rlc	A	;Shift high-byte left with highest bit rotated into carry from low-byte
	mov	R5, A	;Save the updated divisor high-byte
	
	jnc	Step_1  ;Repeat until carry flag is set from high-byte

Step_2:
;Shift the divisor right
	mov	A, R5	;Move high-byte of divisor into accumulator
	rrc	A	;Rotate high-byte of divisor right and into carry
	mov	R5, A	;Save updated value of high-byte of divisor
	
	mov	A, R4	;Move low-byte of divisor into accumulator
	rrc	A	;Rotate low-byte of divisor right, with carry from high-byte
	mov	R4, A	;Save updated value of low-byte of divisor

	clr	cy	;Clear carry, it wouldn't be needed next

	mov	09h, R7	;Make a safe copy of the dividend high-byte
	mov	08h, R6	;Make a safe copy of the dividend low-byte

	mov	A, R6	;Move low-byte of dividend into accumulator
	subb	A, R4	;Dividend - shifted divisor = result bit (no factor, only 0 or 1)
	mov	R6, A	;Save updated dividend
	
	mov	A, R7	;Move high-byte of dividend into accumulator
	subb	A, R5	;Subtract high-byte of divisor (all together 16-bit substraction)
	mov	R7, A	;Save updated high-byte back in high-byte of divisor
	
	jnc	Step_3	;If carry flag is NOT set, result is 1
	mov	R7, 09h	;Otherwise result is 0, restore copy of dividend to undo subtraction
	mov	R6, 08h	;

Step_3:
	cpl	cy	;Invert carry, so it can be directly copied into temporary result
	
	mov	A, R2	;
	rlc	A	;Shift carry flag into temporary result
	mov	R2, A
	
	mov	A, R3
	rlc	A
	mov	R3, A
	
	djnz	B, Step_2	;Now count backwards and repeat until "B" is zero
		

	end

