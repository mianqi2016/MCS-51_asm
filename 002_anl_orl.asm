;demo code for anl and orl

	org	00h

main:
	mov	R7, #0C5h	;set R7 value: 1100 0101B
	
	mov	A, R7	;copy R7 content to ACC
	anl	A, #0F0h	;mask lower nibble, get upper nibble
	mov	R6, A	;copy ACC current value (0xC0 - 1100 0000B) to R6
	swap	A	;xchange upper and lower nibbles of ACC (0x0C - 0000 1100B)
	orl	A, R6	;now A holds 0xCC - 1100 1100B
	mov	R6, A	;copy content in ACC to R6

	end
	