;demo for uart by polling

	org	00h
	sjmp	Setup

Setup:
	mov	SCON, #50h	;mode 1 - 8-bit UART, receiver enabled
	;SCON - SM0/FE - SM1 - SM2 - REN - TB8 - RB8 - TI - RI
	
	mov	TMOD, #20h	;timer 1 in mode 2 - an 8-bit Counter (TLx) with automatic reload, 
				;Overtlow from TLx not only sets TFx, but also reloads TLx with the ecmtentsof THx. 
				;which is preset by software. The reload leaves THx unchanged.
	mov	TH1, #253	;the reload value in TH1 to generate a baud rate of 9600
	setb	TR1	;start timer 1

	sjmp	Receivetext

Sendtext:
	inc	A
	mov	SBUF, A	;move contents of A to serial buffer - this initiates the transmission down the serial line
	jnb	TI, $	;waiting for character to be sent down serial line
	clr	TI	;clear the transmit overflow flag

	mov	A, #'\n'
	mov	SBUF, A
	;mov	SBUF, #'Q'
	jnb	TI, $	;waiting for character to be sent down serial line
	clr	TI	;clear the transmit overflow flag
	
	clr	A
	mov	SBUF, A
	jnb	TI, $	;waiting for character to be sent down serial line
	clr	TI	;clear the transmit overflow flag
	;jmp	Sendtext	;go back to send next character

Receivetext:
	jnb	RI, $	;checks the RI flag to see if the complete bit is recieved
	mov	A, SBUF	;moves recived data to accumulator
	clr	RI	;clears RI flag
	
	;sjmp	Receivetext	;repeats task infinitely

Waiting:
	sjmp	Sendtext

	end

	

	