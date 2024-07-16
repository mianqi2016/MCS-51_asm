;034_stepper_half.asm
;MCU - STC89C516RD+
;Stepper - 28BYJ-48 - Bujin Yongci Jiansu - Unipolar - COM - 5v
;Controller - ULN2003a - inverter buffer
;Number of Phase - 4 - 1/3-2/4
;Stepper Line Color:
;Blue - Phase 1
;Pink - Phase 2
;Yellow - Phase 3
;Orange - Phase 4
;Red - 5v

	stepper	equ	P1	;P1.0-P1.3
	

	org	0000H
	ajmp	Setup

;	Source		Vector Address
;	IEO 		OO03H
;	TFO 		OOOBH
;	IE1 		O013H
;	TF1 		OO1BH
;	RI + TI 	O023H
;	TF2 + EXF2 	O02BH


	org	0030H
Setup:
	nop
	

	org	0100H
Main:
	mov	R2, #120	;120 steps per 90 degree
cw:
	mov	stepper, #0x08	;#~0x07 = 0b0000 1000
	mov	stepper, #0CH	;0x0C = b0000 1100
	;acall	delay_1_second_loop
	acall	delay_10_milliseconds
	;acall	delay_200_milliseconds

	mov	stepper, #0x04	;#~0x0B = 0b0000 0100
	mov	stepper, #06H	;0x06 = b0000 0110
	;acall	delay_1_second_loop
	acall	delay_10_milliseconds
	;acall	delay_200_milliseconds

	mov	stepper, #0x02	;#~0x0D = 0b0000 0010
	mov	stepper, #03H	;0x03 = b0000 0011
	;acall	delay_1_second_loop
	acall	delay_10_milliseconds
	;acall	delay_200_milliseconds

	mov	stepper, #0x01	;#~0x0E = 0b0000 0001
	mov	stepper, #09H	;0x0C = b0000 1001
	;acall	delay_1_second_loop
	acall	delay_10_milliseconds
	;acall	delay_200_milliseconds

	djnz	R2, cw

	mov	R2, #120	;120 steps per 90 degree
ccw:
	mov	stepper, #0x08	;#~0x07
	mov	stepper, #0CH	;0x0C = b0000 1100
	acall	delay_10_milliseconds
	;acall	delay_200_milliseconds

	mov	stepper, #0x01	;#~0x0E
	mov	stepper, #09H	;0x0C = b0000 1001
	acall	delay_10_milliseconds
	;acall	delay_200_milliseconds

	mov	stepper, #0x02	;#~0x0D
	mov	stepper, #03H	;0x03 = b0000 0011
	acall	delay_10_milliseconds
	;acall	delay_200_milliseconds

	mov	stepper, #0x04	;#~0x0B
	mov	stepper, #06H	;0x06 = b0000 0110
	acall	delay_10_milliseconds
	;acall	delay_200_milliseconds

	djnz	R2, ccw	

	sjmp	Main


	org	0200H

delay_1_second_loop:	;create a delay of 1 second by instruction cycle
	mov	R7, #64H	;100us * 100us * 100us = 1s
loop_1:
	mov	R6, #64H
loop_2:
	mov	R5, #64H
loop_3:
	djnz	R5, loop_3
	djnz	R6, loop_2
	djnz	R7, loop_1
	
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

