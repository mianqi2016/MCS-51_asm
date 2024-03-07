;Addition

	;org	00h

	;mov	R2, #03h
	;mov	A, #05h
	;add	A, R2
	;da	A	;da - decimal adjustment

	;end

;find the sum of 10 numbers stored in: 0050h-0059h
;result in R7

	org	00h
	
MAIN:
	mov	R1, #50h	;10 numbers storage start here - 0050h-0059h
	mov	R3, #10	;irerate timers for initialization
	clr	A
	mov	R2, A	;set R2 initial value :00h

INITIA:
	mov	A, R2
	mov	@R1, A	;store back 0-10 Dec into 0050h-0059h
	inc	R1	;using R1 in register addressing
	inc	R2	;using R2 generating 0-10 Dec

	djnz	R3, INITIA	;iterate 9 times
	
	mov	R0, #50h	;using R0 in register addressing
	mov	R2, #10	;;using R2 for 10 times iteration

	clr	A
	mov	R7, A	;using R7 store Carry bits

SUM:
	add	A, @R0	;add up 10 numbers stored by register addressing
	;da	A
	jnc	NEXT_ADD	;no carry skip next instrument
	inc	R7	;incrementing R7 when there is a Carry
	
NEXT_ADD:
	inc	R0	;go forward by R0 register addressing
	djnz	R2, SUM	;add 10 times

	;add	A, R7

	end
	