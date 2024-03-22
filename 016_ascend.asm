;demo ascend sorting in array
;Ascend is a verb that means to move upward, to slope upward, or to rise from a lower level or degree.

	BUBBLE	equ	30h	;the memory address 30h storing intermediate value for sorting algorithm

	org	00h
	sjmp	Setup	;2 bytes instruction

Array:
	DB	35, 76, 98, 123, 99, 65, 23, 54, 86, 31

	org	10h
Setup:
	mov	R1, #0Ah	;Initialize byte counter.
	mov	R0, #3Ah	;Copy array into memory address 3Ah-44h
	;mov	BUBBLE, 3Ah	;the 1st number inside array now stored in BUBBLE
	mov	DPTR, #Array	;Load dptr from array as memory pointer.

Dataload:
	clr	A
	movc	A, @A+DPTR	;Load number in array to memory location 3Ah.
	mov	@R0, A

	inc	R0
	inc	DPTR
	djnz	R1, Dataload

	mov	R2, #09h	;index for number left for ascend sorting

Ascend:
	mov	A, R2
	mov	R1, A		;reload the iterate times into R1
	mov	R0, #3Ah	;repoint R0 to the 1st number in memory
	
Iterate:
	mov	A, @R0	;Load next number into ACC register
	inc	R0
	mov	BUBBLE, @R0

	cjne	A, BUBBLE, Compare	;If current MAX != next number then go to Compare.
	sjmp	Judge

Compare:
	jc	Judge	;If A - current number < the previous number - MAX then go to Judge.

	mov	@R0, A	;store A into the latter number
	dec	R0	;R0 now point to the former number
	mov	@R0, BUBBLE	;store BUBBLE into the former number location
	inc	R0	;restore R0 value
	
Judge:
	djnz	R1, Iterate	;Decrement byte counter by 1, if it != 0, then go to Iterate.

	djnz	R2, Ascend	;Ascend all numbers inside array
	
	end
