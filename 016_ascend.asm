;ascend sorting
;Ascend is a verb that means to move upward, to slope upward, or to rise from a lower level or degree.

	org	00h
	sjmp	Setup

	MOV R0, #0AH ; Initialize pass counter.

REP1: MOV DPTR, #4000H ; Initialize memory pointer

MOV R1, #0AH ; Initialize byte counter

REPEAT: MOV R2, DPL ; Save the lower byte address

MOVX A, @DPTR ; Read the number from array

MOV 0F0H, A ; Store the number in register B

INC DPTR ; Increment memory pointer

MOVX A, @DPTR ; Take the next number from array

CJNE A, 0F0H, NEXT ; Compare number with next number

AJMP SKIP ; Jump to SKIP unconditionally

NEXT: JNC SKIP ; If number>next number then go to SKIP

MOV DPL, R2 ; Else exchange the number with next number

MOVX @DPTR, A ; Copy greater number to memory location

INC DPTR ; Increment memory pointer

MOV A, 0F0H

MOVX @DPTR, A

SKIP: DJNZ R1, REPEAT ; Decrement byte counter by 1, if byte counter\u2260 0 then go to REPEAT.

DJNZ R0, REP1 ; Decrement pass counter if not zero then go to REP1

STOP: AJMP STOP ; Stop