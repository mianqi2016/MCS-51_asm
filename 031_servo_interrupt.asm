;030_servo_interrupt
;MCU - STC89C516RD+
;Servo(micro servo) - Tower Pro MG90S

;main.asm
	PIN_SERVO	bit	P2.0

	org	0000H
	ajmp	Setup

;	Source		Vector Address
;	IEO 		OO03H
;	TFO 		OOOBH
;	IE1 		O013H
;	TF1 		OO1BH
;	RI + TI 	O023H
;	TF2 + EXF2 	O02BH

	org	001BH
	ajmp	ISR_Timer1_Servo
	

	org	0030H
Setup:
	clr	A
	mov	R0, A	;R0 acts as degree flag
	mov	R1, A	;R1 acts as level-shifting flag

	mov	TMOD, #0x20
	;Using Timer1 in mode_2 - configures the Timer register as an 8-bit Counter with automatic reload,
	;Overflow from TL1 not only sets TF1, but also reloads TL1 with the contents of TH1, 
	;which is preset by aoftware. The reload leave TH1 unchanged.

	;F_CPU = 11059200Hz
	;the count rate is 1/12 of the oscillator frequency.
	;11059200/12=921600:
	;20ms=921600/18432=0x4800
	;18432/128=144
	;255-128+1=128	TL0 reload-value
	
	mov	TL1, #255
	mov	TH1, #128	;Timer1 reload-value
	
	mov	IE, #88H	;Enable genaral interrupt and Timer1 interrupt

	setb	TR1	;start Timer1
	

	org	0100H
Main:
	mov	R0,  #0		;Angle_0_degree
	;lcall	delay_200_milliseconds
	lcall	delay_1_second_loop

	mov	R0,  #45	;Angle_45_degree
	;lcall	delay_200_milliseconds
	lcall	delay_1_second_loop

	mov	R0,  #90	;Angle_90_degree
	;lcall	delay_200_milliseconds
	lcall	delay_1_second_loop

	mov	R0,  #135	;Angle_135_degree
	;lcall	delay_200_milliseconds
	lcall	delay_1_second_loop

	mov	R0,  #180	;Angle_180_degree
	;lcall	delay_200_milliseconds
	lcall	delay_1_second_loop

	sjmp	Main
	

	org	0200H
ISR_Timer1_Servo:
;F_CPU = 11059200Hz
;the count rate is 1/12 of the oscillator frequency.
;11059200/12=921600
;20ms=921600/18432=0x4800
;18432/128=144
;255-128+1=128	TL1 reload-value

;zero degree	0.5ms		0.5/20*144=3.6		almost=4
;45 degree	1ms		1/20*144=7.2		almost=7
;90 degree	1.5ms		1.5/20*144=10.8		almost=11
;135 degree	2ms		2/20*144=14.4		almost=14
;180 degree	2.5ms		2.5/20*144=18		almost=18

	inc	R1
	cjne	R1, #144, SET_SERVO_DEGREE
	clr	A
	mov	R1, A
	setb	PIN_SERVO
	reti
SET_SERVO_DEGREE:
	cjne	R0, #0, SERVO_DEGREE_45
	cjne	R1, #2, OUT_OF_INTERRUPT
	clr	PIN_SERVO
	reti
SERVO_DEGREE_45:
	cjne	R0, #45, SERVO_DEGREE_90
	cjne	R1, #6, OUT_OF_INTERRUPT
	clr	PIN_SERVO
	reti
SERVO_DEGREE_90:
	cjne	R0, #90, SERVO_DEGREE_135
	cjne	R1, #10, OUT_OF_INTERRUPT
	clr	PIN_SERVO
	reti
SERVO_DEGREE_135:
	cjne	R0, #135, SERVO_DEGREE_180
	cjne	R1, #14, OUT_OF_INTERRUPT
	clr	PIN_SERVO
	reti
SERVO_DEGREE_180:
	cjne	R0, #180, SET_SERVO_DEGREE
	cjne	R1, #18, OUT_OF_INTERRUPT
	clr	PIN_SERVO
	reti
	
OUT_OF_INTERRUPT:
	reti
	

	org	0300H

delay_1_second_loop:	;create a delay of 1 second by instruction cycle
	mov	R4, #64H	;100us * 100us * 100us = 1s
loop_1:
	mov	R3, #64H
loop_2:
	mov	R2, #64H
loop_3:
	djnz	R2, loop_3
	djnz	R3, loop_2
	djnz	R4, loop_1
	ret
	
delay_100_microseconds:
	mov	R7, #100
delay_1:
	djnz	R7, delay_1
	ret
	
delay_1_millisecond:
	mov	R6, #10
delay_2:
	acall	delay_100_microseconds
	djnz	R6, delay_2
	ret

delay_10_milliseconds:
	mov	R5, #10
delay_3:
	acall	delay_1_millisecond
	djnz	R5, delay_3
	ret

delay_100_milliseconds:
delay_4:
	mov	R5, 100
	acall	delay_1_millisecond
	djnz	R5, delay_4
	ret

delay_200_milliseconds:
delay_5:
	mov	R5, 200
	acall	delay_1_millisecond
	djnz	R5, delay_5
	ret

	end
	