;demo for XRL

	org	00h

MAIN:
	mov	R2, #55h
	mov	R3, #0AAh
	mov	R5, #55h
	mov	R6, #0AAh

XOR:
	mov	A, R2
	xrl	A, R3
	mov	R4, A

	mov	A, R5
	xrl	A, R6
	mov	R7, A
	mov	R6, A

	sjmp	XOR

	end
	