;demo instuction "da A" - decimal adjust for addition
;The DA A instruction is for BCD arithmetic operations. 
;In BCD arithmetic, ADD and ADDC instructions should always be followed by a DA A operation,
;to ensure that the result is also in BCD.
;Note that DA A will not convert a binary number to BCD. 
;The DA A operation produces a meaningful result only as the second step in the addition of two BCD bytes.
;DA must be used after the addition of BCD operands and that BCD operands can never have any digit greater than 9. 
;In other words, A - F digits are not allowed. 
;DA works only after an ADD instruction; it will not work after the INC instruction.
;In reality there is no other use for the AC (auxiliary carry) flag bit except for BCD addition and correction.

	org	00h

	mov	A, #19h	;operand shoule be HEX not DEC
	add	A, #39h	;52h is got, although 58h is expected
	da	A	;now, got 58h

	clr	A

	mov	A, #76h
	add	A, #23h	;99h is got and expected
	da	A	;the result is restain after "da A"

	end

	