;demo of uart

	org	00h
	sjmp	Setup	;sjmp used to bypass the ISR

	org	0023h	;location for ISR for both TI and RI
	sjmp	Uart	;ISR for UART receiving
	sjmp	$	;halting


Setup:
	mov	SCON, #50h	;set the serial communication - mode 1 with the receiver enabled
	;SCON - Serial Port Control Register
	;SCON - Address:0098h - Reset Value:0000 0000B
	;SCON - SM0/FE - SM1 - SM2 - REN - TB8 - RB8 - TI - RI
	;For mode 1 in full-duplex, the value 50H should be inserted into SCON register
	;For mode 1 in half-duplex, the value 40H should be inserted into SCON register
	mov	IE, #10010000B; enables general interrupt and serial interrupt which can be caused by both TI/RI

	;timer 1 is set to mode 2 auto-reload in which every time the timer overflows 
	;the value in TH1 is reloaded into TL1, and the timer counts up from the value fed into it.
	mov	TMOD, #20h
	mov	TH1, #0FDh	;TH1 = FDh; when SMOD=0, baud rate:9600
	setb	TR1

	;mov	PCON, 80h  	;PCON - power control register - Address - 0087h
	;PCON controls the Power Reduetion Modes. Idle and Power Down Modes
	;reset value - 00xx 0000B
	;SMOD1 - SMODO - x - POF - GF1 - GFO - PD - IDL
	;Bit 7 of the PCON register - SMOD can be used to double the baud rate. 
	;When the SMOD bit is set to 0 the value of the dividing factor changes from 32 to 16 
	;due to which the baud rate doubles.
	;SMOD1 Double Baudrate bit. When set to a 1 and Timer1 is used to generate baud rates,
	;and the Serial Port is used in modes 1, 2, or 3.

	sjmp	$	;halting


Uart:
	jb	TI, Uart_tx	;if the interrupt is caused by T1 control is transferred to trans 
				;as the old data has been transferred and new data can be sent to the SBUF
	mov	A, SBUF	;otherwise the interrupt was caused due to RI and received data is put into the accumulator.
	;SBUF - serial buffer register - Address - 0099h
	clr	RI
	;reti	;transfers control from receive to main
	cjne	A, #013, Print_nl	;'\n'=013
	mov	A, #012	;
	
Print_nl:
	inc	A
	mov	SBUF, A
	;clr	TI
	reti
	
Uart_tx:
	;inc	A
	;mov	SBUF, A
	clr	TI
	reti	;transfers control from transmition to main

	end

	