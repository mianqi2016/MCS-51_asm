;the 2nd demo for mul

	org 00h

Main: 
	mov R0, #20h	; memory to store products.
	mov R1, #20h
	mov R2, #1	; row
	mov R3, #1	; column

Newline:
	mov A, R1	; for updating R0
	add A, #8	; locate to new line
	mov R1, A
	mov R0, A

	mov R3, #1	; start from a new column

Multiply:
	mov A, R2
	mov B, R3
	mul AB
	mov @R0, A

	inc R0		; next position
	inc R3		; next column

	mov A, R3	; R2 ?= R3
	mov 80h, R2
	cjne A, 80h, Judge	; if R2 == R3, start a new line
	sjmp Multiply

Judge:	
	jc Multiply

	inc R2
	cjne R2, #9, Newline

	end
	
	