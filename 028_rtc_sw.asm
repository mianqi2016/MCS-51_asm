;Software RTC

HOURS           EQU 	035h        ;HOURS variable
MINUTES         EQU 	036h        ;MINUTES variable
SECONDS         EQU 	037h        ;SECONDS variable
TICKS           EQU 	033h        ;20th of a second countdown timer

COLONS		EQU 	058		;colons ascii code

;CRYSTAL         EQU 11059200         ;The crystal speed
;TMRCYCLE        EQU 12               ;The number of crystal cycles per timer increment

;TMR_SEC	        EQU CRYSTAL/TMRCYCLE 	;11059200 / 12 = 921600 - The # of timer increments per second

;F20TH_OF_SECOND EQU TMR_SEC * .05	;921600 × 0.05 = 46080 = B400h

;F20TH_OF_SECOND EQU 	0B400h
;RESET_VALUE     EQU 	65536-F20TH_OF_SECOND	;65536 - 46080 = 19456 = 4C00h
RESET_VALUE     EQU 	4C00h		;65536 - 46080 = 19456 = 4C00h

	org	0000h
	sjmp	Setup	;2 bytes instruction

	org	000Bh	;This is where Timer 0 Interrupt Routine starts
	push	ACC	;We'll use the accumulator, so we need to protect it
	push	PSW	;Protect PSW flags
	
	clr	TR0	;Turn off timer 1 as we reset the value
	mov	TH0, #HIGH RESET_VALUE ;Set the high byte of the reset value
	mov	TL0, #LOW RESET_VALUE  ;Set the low byte of the reset value
	setb	TR0	;Restart timer 1 now that it has been initialized

	djnz	TICKS, Exit_RTC       ;Decrement TICKS, if not yet zero we exit immediately

;	mov	A, #'T'
;	mov	SBUF, A		;SBUF - serial buffer register - Address - 0099h
;	jnb	TI, $
;	clr	TI

	acall	Print_rtc

	mov	TICKS, #20		;Reset the ticks variable
	inc	SECONDS			;Increment the second varaiable
	mov	A, SECONDS		;Move the seconds variable into the accumulator
	cjne	A, #60, Exit_RTC	;If we haven't counted 60 seconds, we're done.
	mov	SECONDS, #0		;Reset the seconds varaible
	inc	MINUTES			;Increment the number of minutes
	mov	A, MINUTES		;Move the minutes variable into the accumulator
	cjne	A, #60, Exit_RTC	;If we haven't counted 60 minutes, we're done
	mov	MINUTES, #0		;Reset the minutes variable
	inc	HOURS			;Increment the hour variable

Back_interrupt:
	pop	PSW                   ;Restore the PSW register
	pop	ACC                   ;Restore the accumulator

	reti

Exit_RTC:
	sjmp	Back_interrupt       ;Exit the interrupt routine

Setup:
	mov	TH0, #HIGH RESET_VALUE ;Initialize timer high-byte
	mov	TL0, #LOW RESET_VALUE  ;Initialize timer low-byte
	mov	TMOD, #21h             ;Set timer 0 to 16-bit mode, timer 1 to mode 2
	setb	TR0                  ;Start timer 0 running
	setb	TR1                  ;Start timer 1 running	

	mov	HOURS, #12	;Initialize to 0 hours
	mov	MINUTES, #34	;Initialize to 0 minutes
	mov	SECONDS, #56	;Initialize to 0 seconds
	mov	TICKS, #20	;Initialize countdown tick counter to 20

;	mov	38h, #1
;	mov	39h, #2
;	mov	3Ah, #58
;	mov	3Bh, #3
;	mov	3Ch, #4
;	mov	3Dh, #58
;	mov	3Eh, #5
;	mov	3Fh, #6

	setb	EA	;Initialize interrupts
	setb	ET0     ;Initialize Timer 0 interrupt
	setb	ES	;Serial Port interrupt enable bit.

	mov	TH1, #0FDh	;Disable Timer 1 interrupt - baud rate generator - 9600 - reload value

	mov	SCON, #40h	;set the serial communication - mode 1 - 8-bit uart with Receive disabled

	mov	R2, #8		;iterate in ascii to be printed
	mov	R0, #38h	;the entry in memory for result to br printed

	sjmp	$

Print_rtc:	;for debugging
	acall	Dec_to_ascii

	mov	R0, #38h
	mov	R2, #8
	acall	Uart_tx

;	clr	TI
;	mov	A, #'T'
;	mov	SBUF, A
;	jnb	TI, $
;	clr	TI

	ret
	
	
Dec_to_ascii:
	clr	A
	mov	B, A
	mov	A, 035h
	mov	B, #10
	div	AB
	orl	A, #30h
	mov	38h, A
	orl	B, #30h
	mov	39h, B
	mov	3Ah, #':'

	clr	A
	mov	B, A
	mov	A, 036h
	mov	B, #10
	div	AB
	orl	A, #30h
	mov	3Bh, A
	orl	B, #30h
	mov	3Ch, B
	mov	3Dh, #':'

	clr	A
	mov	B, A
	mov	A, 037h
	mov	B, #10
	div	AB
	orl	A, #30h
	mov	3Eh, A
	orl	B, #30h
	mov	3Fh, B

	ret

Uart_tx:
	clr	TI
	mov	A, @R0
	mov	SBUF, A		;SBUF - serial buffer register - Address - 0099h
	jnb	TI, $	;waiting until tranceiving finished
	clr	TI

	;The Serial Port Interrupt is generatedby the logical OR of RI and TI. 
	;Neither of these flags is cleared by hardware when the cervix routine ia vectored to. 
	;In fact, the service routine will normally have to determine 
	;whether it was RI or TI that generated the interrupt, and the bit will have to be cleared in software.

	inc	R0
	djnz	R2, Uart_tx

	clr	TI
	mov	A, #'\n'
	mov	SBUF, A
	jnb	TI, $
	clr	TI

	ret

Print_colons:
	mov	A, #058		;':'= 058
	mov	SBUF, A
	ret
	
Print_nl:
	clr	TI
	mov	A, #013		;'\n'= 013
	mov	SBUF, A
	jnb	TI, $
	clr	TI
	ret
	
Endpoint:
	end

	