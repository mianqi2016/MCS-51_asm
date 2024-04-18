;demo for overflow flag
;Signed overflow occurs when the result of addition is too large for a given type to represent.

;There are two conditions when the overflow flag is set
;When there is carry from D6 to D7, but no carryout from D7.
;When there is a carryout from D7, but no carry from D6 to D7.

;The overflow flag is another flag in the PSW register, which is used to alert the programmer 
;if an arithmetic calculation has not provided the correct result. 
;in the case of signed numbers, the 8051 uses 7 bits to represent the magnitude of numbers. 
;This provides a range from +127 to -128. If the result of an arithmetic operation is out of this range, 
;then the overflow bit is raised to tell the programmer that the result is incorrect.

;OV (overflow flag):
;This flag is set whenever the result of a signed number operation is too large
;causing the high order bit to overflow into the sign bit range (-128 to 127)
;the OV flag is only used to detect error in signed arithmetic operations.

;How does the processor comes to know about overflow ?
;XOR operation is performed on C6 and C7 carry. C0 is carried from 0th bit to 1st bit and so on. 
;If the XOR operation gives output as 1, then the operation is going out of the limit.

;The operations for signed and unsigned numbers are the same, but signed numbers overflow between bit 6 and 7, 
;while unsigned numbers overflow between bit 7 and 8.

;The OV flag represents the overflow into bit 7, while the CY flag represents the overflow into bit 8, 
;so for a signed operation, you'd check the OV flag, 
;while for an unsigned operation you'd check the CY flag after the operation.

;DIVISION :
;A / B If B = 0, OV = 1 indicates error
;If B != 0 , OV = 0

	org	00h
	sjmp	DivideZero	;2-byte instruction

DivideZero:
	clr	A
	mov	B, A

	mov	B, #01
	mov	A, #0

	div	AB

	clr	A
	mov	B, A
	
	mov	B, #0
	mov	A, #01

	div	AB
	
OverFlow:
;Negative numbers is done is by using 7 bits of the registers as magnitude bits and the 8th bit as the sign bit.
;It is the responsibility of the programmer to look at the carry and overflow flags in the PSW register to determine the correct answer.

;ov set in add
	acall	RegisterReset
	
	mov	B, #0FEh	;-2 - 1111 1110B
	mov	A, #80h		;-128 - 1000 0000B

	add	A, B		;-130 overflow -128

	acall	RegisterReset

	mov	A, #7Fh		;0111 1111B - 127
	mov	B, #03h		;0000 0011B - 3
	add	A, B		;130 overflow 127

	acall	RegisterReset

	mov	A, #0CAh	;-54 - 1100 1010B
	mov	B, #0B1h	;-79 - 1011 0001B
	add	A, B		;-133 overflow -128

;ov not set in add

	acall	RegisterReset

	mov	A, #2Dh		;0010 1101B - 45
	mov	B, #15h		;0001 0101B - 21
	add	A, B		;66 not overflow 127

;ov not set in subb

	acall	RegisterReset

	mov	A, #41h		;0100 0001B - 65
	mov	B, #7Bh		;0111 1011B - 123
	subb	A, B		;-58 not overflow -128

	acall	RegisterReset

	mov	A, #0B1h	;1011 0001B - -79
	mov	B, #0DDh	;1101 1101B - -35
	subb	A, B		;-44 not overflow -128

;ov set in subb

	acall	RegisterReset

	mov	A, #3Bh		;0011 1011B - 59
	mov	B, #84h		;1000 0100B - -124
	subb	A, B		;183 overflow 127


	sjmp	Stop

RegisterReset:
	clr	PSW.2	;OV - overflow
	clr	PSW.7	;CY - carry
	clr	PSW.6	;AC - auxiliary carry
	clr	A
	mov	B, A

	ret

	
Stop:
	end

	