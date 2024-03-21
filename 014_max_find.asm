;demo find MAX in array

	MAX	equ	30h	;the final result - MAX stored in 30h of memory

	org	00h
	sjmp	Setup	;2 bytes instruction

Array:
	DB	35, 76, 98, 123, 99, 65, 23, 54, 86, 131

	org	10h
Setup:
	mov	R1, #0Ah	;Initialize byte counter.
	mov	DPTR, #Array	;Load dptr from array as memory pointer.
	clr	A
	movc	A, @A+DPTR	;Load number in array to memory location 30h.
	mov	MAX, A
	dec	R1

Iterate:
	inc	DPTR	;Increment memory pointer by 1.
	clr	A
	movc	A, @A+DPTR	;Load next number into ACC register

	cjne	A, MAX, Compare	;If current MAX != next number then go to Compare.
	
	sjmp	Judge

Compare:
	jc	Judge	;If A - current number < the previous number - MAX then go to Judge.
	mov	MAX, A	;replace MAX with current number.

Judge:
	djnz	R1, Iterate	;Decrement byte counter by 1, if it != 0, then go to Iterate.
	
	end

	