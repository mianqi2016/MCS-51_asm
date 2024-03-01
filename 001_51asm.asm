;MCU - 8051
;To right-shift by an odd number of digits, a one-digit shift must be executed.

;a sample of code that will right-shift a BCD number one digits using the XCHD instruction.

;The XCH A, <byte> instruction causes the Accmulator and addressed byte to exchsnge data. 
;The XCHD A, @Ri instruction is similar, but only the low nibbles are involved in the exchange.

;XCHD A, @Ri - 1 Byte, 1 Cycle
;SWAP A - 1 Byte, 1 Cycle

	org	00h
	
;initialization - setting starting values
main:	
;headlines
	mov	22h, #00h
	mov	23h, #12h
	mov	24h, #34h
	mov	25h, #56h
	mov	26h, #78h

	mov	32h, #2Ah
	mov	33h, #2Bh
	mov	34h, #2Ch
	mov	35h, #2Dh
	mov	36h, #2Eh

;initialization
	mov	2Ah, #00h
	mov	2Bh, #12h
	mov	2Ch, #34h
	mov	2Dh, #56h
	mov	2Eh, #78h

;the method without iteration loop - shifting 4 times
;using R1 and R0 (R1|R0 : Ri) as pointer (addressing register)
;---------- 0 ---------- 00 12 34 56 78 A ----------------------------------

	mov R1, #2Eh	;R1 now holds address 2Eh
	mov R0, #2Dh	;R1 now holds address 2Dh
	
	mov	A, @R1	;A now holds BCD 78h, Address indirected by R1 now still holds 78h
	xchd	A, @R0	;A now holds BCD 76h, Address indirected by R0 now holds 58h 
	swap	A	;A now holds 67h
	mov	@R1, A	;Address indirected by R1 now still holds 67h	
;---------- 1 ---------- 00 12 34 58 67 A(67) ------------------------------

	mov R1, #2Dh	;R1 now holds address 2Dh
	mov R0, #2Ch	;R0 now holds address 2Ch

	mov	A, @R1	;A now holds BCD 58h, Address indirected by R1 now still holds 58h
	xchd	A, @R0	;A now holds BCD 54h, Address indirected by R0 now holds 38h 
	swap	A	;A now holds 45h
	mov	@R1, A	;Address indirected by R1 now still holds 45h	
;---------- 2 ---------- 00 12 38 45 67 A(45) ------------------------------

	mov R1, #2Ch	;R1 now holds address 2Ch
	mov R0, #2Bh	;R0 now holds address 2Bh

	mov	A, @R1	;A now holds BCD 38h, Address indirected by R1 now still holds 38h
	xchd	A, @R0	;A now holds BCD 32h, Address indirected by R0 now holds 18h 
	swap	A	;A now holds 23h
	mov	@R1, A	;Address indirected by R1 now still holds 23h	
;---------- 3 ---------- 00 18 23 45 67 A(23) ------------------------------

	mov R1, #2Bh	;R1 now holds address 2Bh
	mov R0, #2Ah	;R0 now holds address 2Ah

	mov	A, @R1	;A now holds BCD 18h, Address indirected by R1 now still holds 18h
	xchd	A, @R0	;A now holds BCD 10h, Address indirected by R0 now holds 08h 
	swap	A	;A now holds 01h
	mov	@R1, A	;Address indirected by R1 now still holds 01h
;---------- 4 ---------- 00 01 23 45 67 A(01) ------------------------------

	clr	A	;1 Byte, 1 Cycle
	xch	A, 2AH	;let address 2Ah now holds 00h


method2:	
	mov	2Ah, #00h
	mov	2Bh, #12h
	mov	2Ch, #34h
	mov	2Dh, #56h
	mov	2Eh, #78h

	mov R1, #2Eh	;R1 now holds address 2Eh
	mov R0, #2Dh	;R1 now holds address 2Dh

;the method optimized using iteration loop
;using xchd and swap instructions for A register
loop:	mov	A, @R1
	xchd	A, @R0
	swap	A
	mov	@R1, A
	dec	R1
	dec	R0
	cjne	R1, #2Ah, loop

	clr	A
	xch	A, 2AH

	end
	