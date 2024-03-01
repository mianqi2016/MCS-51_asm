; MCU  - 8051
; shift 2 digits BCD (1 byte) right - shiting an 8-digit BCD number two digits to the right

; 12 MHz - default frequency - 1 cycle = 1 us (micro second)

; Press F2 and F6 to run the program (start simulator and animate)

	org	00h
	
main:	
	mov	2Ah, #00h	;mov direct, #data - 3 Bytes, 2 Cycles
	mov	2Bh, #12h
	mov	2Ch, #34h
	mov	2Dh, #56h
	mov	2Eh, #78h
;above is initialization, below are 2 methods

;method 1 - 14 bytes with 9 cycles
	mov	A, 2Eh		;mov A, direct - 2 Bytes, 1 Cycle
	mov	2Eh, 2Dh	;mov direct, direct - 3 Bytes, 2 Cycles
	mov	2Dh, 2Ch
	mov	2Ch, 2Bh
	mov	2Bh, #0		;mov direct, #data - 3 Bytes, 2 Cycles

;method 2 - 9 bytes with 5 cycles
;	clr	A		;Clear Accumulator - 1 Byte, 1 Cycle - will leave A set to 00h (00000000b)
;	xch	A, 2Bh		;xch A, direct - 2 Byte, 1 Cycle - the 1st operand must be A register (Accumulator)
;	xch	A, 2Ch
;	xch	A, 2Dh
;	xch	A, 2Eh

	end
	