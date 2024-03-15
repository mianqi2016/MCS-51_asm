;copies the data from R0 of Bank0 to R0 of Bank3.

	org	00h

MAIN:
	mov	R0, #0A5h
	mov	A, R0

Bank3:	setb	PSW.3
	setb	PSW.4

	mov	R0, A

Bank0:	clr	PSW.3
	clr	PSW.4

	mov	R0, #30h	;set R0 addressing 0030h
	inc	R0
	mov	@R0, #012h

Bank3_1:	
	setb	PSW.3
	setb	PSW.4

	mov	R0, #35h	;set R0 addressing 0030h
	inc	R0
	mov	@R0, #034h

	end

	
	

	

	end

	