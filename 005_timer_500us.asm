;calculate the 500us time delay.
;adjusted to 50 microsecond for fast demo

	org	00h

	mov	TMOD, #10h	;set Timer1 mode - mode 1 - 16-bit Timer
	;mode 1: 16-bit Timer/Counter.THx and TLx are cascaded;there is no prescaler.
	;mov	TH1, #0FEh	;Higher bits of Timer1 - 11.059200 MHz
	;mov	TL1, #32h	;Lower bits of Timer1 - 11.059200 MHz
	;65535-461=65074=FE32h

	;mov	TH1, #0FEh	;Higher bits of Timer1 - 12 MHz
	;mov	TL1, #15h	;Lower bits of Timer1 - 12 MHz
	;65535-496=65039=FE0Fh

	;50 microsecond for fast demo
	mov	TH1, #0FFh	;Higher bits of Timer1 - 12 MHz
	mov	TL1, #0D2h	;Lower bits of Timer1 - 12 MHz
	;65535-45=65490=FFD2h

	setb	TR1	;start Timer1

	jnb	TF1, $	;waiting for TF1 equals 1
	clr	TR1	;stop Timer1
		
	clr	TF1	;clear flag bit

	ret

	end
	