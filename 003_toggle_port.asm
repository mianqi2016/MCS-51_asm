;toggle the PORT1 LEDs

	org	00h

TOGGLE: 
	mov	P1, #01h	;move 00000001 to p1ort1 register
	call	DELAY	;execute the delay
	
	mov	A, P1	;move p1 value to accumulator
	cpl	A	;complement A value
	mov	P1, A	;move 11111110 to port1 register
	call	DELAY	;execute the delay

	sjmp	TOGGLE

DELAY:
	mov	R2, #2h	;load register R2 with 10h

OUTER:	mov	R3, #5h	;load register R3 with 20h
MIDDLE:	mov	R4, #5h	;load register R4 with 20h
INNER:	mov	R5, #5h	;load register R5 with 20h
	djnz	R5, $	;decrease R5 till it is zero
	djnz	R4, INNER	;decrease R4 till it is zero
	djnz	R3, MIDDLE	;decrease R3 till it is zero
	djnz	R2, OUTER	;decrease R2 till it is zero

	ret	;go back to main branch

	end

	