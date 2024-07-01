;030_servo_no_interrupt
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
;	TF1 		OOIBH
;	RI + TI 	O023H
;	TF2 + EXF2 	O02BH

	org	0030H
Setup:
	mov	TMOD, #01H	
	;Using Timer0 in mode_1 - 16-bit Timer/Counter "THx" and "TLx" are cascaded, no prescaler.

	org	0100H
Main:

	mov	R6, 2
Turn_0_degree:		;-90 degree
	lcall	Angle_0_degrees
	djnz	R6, Turn_0_degree
	;lcall	delay_1_second_loop

	mov	R6, 2
Turn_45_degree:		;-45 degree
	lcall	Angle_45_degrees
	djnz	R6, Turn_45_degree
	;lcall	delay_1_second_loop

	mov	R6, 2
Turn_90_degree:		;Zero degree
	lcall	Angle_90_degrees
	djnz	R6, Turn_90_degree
	;lcall	delay_1_second_loop

	mov	R6, 2
Turn_135_degree:	;45 degree		
	lcall	Angle_135_degrees
	djnz	R6, Turn_135_degree
	;lcall	delay_1_second_loop

	mov	R6, 2
Turn_180_degree:	;90 degree	
	lcall	Angle_180_degrees
	djnz	R6, Turn_180_degree
	;lcall	delay_1_second_loop

	sjmp	Main

	org	0200H
ISR_Timer0_Servo:
;F_CPU = 11059200Hz
;the count rate is 1/12 of the oscillator frequency.
;11059200/12=921600:
;1ms almost= 921(921.6) or 922, select 922=0x39A, 65535-922+1=0xFC66
;20ms = 921600/50=18432=0x4800, 65535-18432=1=47104=0xB800
;0.5ms=460.8=461=01CDH, FFFFH-01CDH+1=FE33H
;19.5ms=921.6*19.5=17971.2=17971=4633H, FFFFH-4633H+1=B9CDH
;4800H-01CDH=4633H
;1ms=922H=039AH, FFFFH-039AH+1=FC66H
;19ms=921.6*19=17510.4=17510=4466H, FFFFH-4466H+1=BB9AH
;4800H-039AH=4466H
;1.5ms=921.6*1.5=1382.4=1382=0566H, FFFFH-0566H+1=FA9AH
;18.5ms=921.6*18.5=17049.6=17050=429AH, FFFFH-429AH+1=BD66H
;4800H-0566H=429AH
;2ms = 921600/500=1843.2 almost=1843=0x733, FFFFH-733H+1=F8CDH
;18ms=921.6*18=16588.8=16589=40CDH, FFFFH-40CDH+1=BF33H
;4800H-0733H=40CDH
;2.5ms=921.6*2.5=2304=900H, FFFFH-900H+1=F700H
;17.5ms=921.6*17.5=16128=3F00H, FFFFH-3F00H+1=C100H
;4800H-0900H=3F00H
;0.5ms=-90 degree, 1ms=-45 degree, 1.5ms=zero degree, 2ms=45 degree, 2.5ms=90 degree

Angle_0_degrees:	;pulse width = 0.5ms

Duty_cycle_high_zero:
	clr	TR0
	mov	TH0, #0FEH
	mov	TL0, #33H
	setb	PIN_SERVO	;Make P2.0 HIGH
	setb	TR0	;Start Timer0
	
	jnb	TF0, $
	clr	PIN_SERVO
	clr	TF0
Duty_cycle_low_zero:
	clr	TR0
	mov	TH0, #0B9H
	mov	TL0, #0CDH
	clr	PIN_SERVO	;Make P2.0 LOW
	setb	TR0	;Start Timer0

	jnb	TF0, $
	setb	PIN_SERVO
	clr	TF0
	ret
	
Angle_45_degrees:	;pulse width = 1ms

Duty_cycle_high_45:
	clr	TR0
	mov	TH0, #0FCH
	mov	TL0, #066H
	setb	PIN_SERVO	;Make P2.0 HIGH
	setb	TR0	;Start Timer0

	jnb	TF0, $
	clr	PIN_SERVO
	clr	TF0
Duty_cycle_low_45:
	clr	TR0
	mov	TH0, #0BBH
	mov	TL0, #09AH
	clr	PIN_SERVO	;Make P2.0 LOW
	setb	TR0	;Start Timer0

	jnb	TF0, $
	setb	PIN_SERVO
	clr	TF0
	ret

Angle_90_degrees:	;pulse width = 1.5ms

Duty_cycle_high_90:
	clr	TR0
	mov	TH0, #0FAH
	mov	TL0, #09AH
	setb	PIN_SERVO	;Make P2.0 HIGH
	setb	TR0	;Start Timer0

	jnb	TF0, $	;Wait till the TF0 flag is set
	clr	PIN_SERVO	;Make P2.0 LOW
	clr	TF0	;Clear the TF0 flag manually
Duty_cycle_low_90:
	clr	TR0
	mov	TH0, #042H
	mov	TL0, #9AH
	clr	PIN_SERVO	;Make P2.0 LOW
	setb	TR0	;Start Timer0

	jnb	TF0, $	;Wait till the TF0 flag is set
	setb	PIN_SERVO	;Make P2.0 LOW
	clr	TF0	;Clear the TF0 flag manually
	ret

Angle_135_degrees:	;pulse width = 2ms

Duty_cycle_high_135:
	clr	TR0
	mov	TH0, #0F8H
	mov	TL0, #0CDH
	setb	PIN_SERVO	;Make P2.0 HIGH
	setb	TR0	;Start Timer0

	jnb	TF0, $
	clr	PIN_SERVO
	clr	TF0
Duty_cycle_low_135:
	clr	TR0
	mov	TH0, #0BFH
	mov	TL0, #033H	
	clr	PIN_SERVO	;Make P2.0 LOW
	setb	TR0	;Start Timer0

	jnb	TF0, $
	setb	PIN_SERVO
	clr	TF0
	ret

Angle_180_degrees:	;pulse width = 2.5ms

Duty_cycle_high_180:
	clr	TR0
	mov	TH0, #0F7H
	mov	TL0, #00H
	setb	PIN_SERVO	;Make P2.0 HIGH
	setb	TR0	;Start Timer0

	jnb	TF0, $	;Wait till the TF0 flag is set
	clr	PIN_SERVO	;Make P2.0 LOW
	clr	TF0	;Clear the TF0 flag manually
Duty_cycle_low_180:
	clr	TR0
	mov	TH0, #0C1H
	mov	TL0, #00H
	clr	PIN_SERVO	;Make P2.0 LOW
	setb	TR0	;Start Timer0

	jnb	TF0, $	;Wait till the TF0 flag is set
	setb	PIN_SERVO	;Make P2.0 LOW
	clr	TF0	;Clear the TF0 flag manually
	ret

	org	0F00H	;F_CPU = 12MHz

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

	end
	