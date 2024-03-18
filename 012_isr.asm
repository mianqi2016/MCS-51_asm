;assign Rn value in Timer0 ISR


	org	00h
	sjmp	Main

	org	000Bh	;000Bh - Timer0 interrupt vector address
	sjmp	ISR_TIMER0
	sjmp	Run
	

Main:	
	mov	IE, #82h	;enable general interrupt and Timer1 interrupt, Timer0 interrupt
	mov	SP, #30h	;set RAM location 28h as the first stack location
	mov	R2, #00h	;set initial value of R2 to 00h

	mov	TMOD, #02h	;set Timer0 as 8-bit timer(counting machine cycle) - M01:M00 - 1:0.
	;Mode 2 configures the Timer registeras an 8-bit Counter (TLx) with automatic reload, 
	;Overflow from TLx not only sets TFx, but also reloads TLx with the contents of THx. which is preset by software.
	;The reload leaves THx unchanged.
	;TMOD - GATE C/~T M1 M0 GATE C/~T M1 M0

	mov	TH0, #250	;reload value for Timer0, 
	mov	TL0, #250	;set TL0 with iniatial value - 00h
	setb	TR0	;start Timer0, Timer0 overflow every 6 counts

Run:	sjmp	$

ISR_TIMER0:
	inc	R2	;increase R2
	;push	2
	
	reti

	end
	