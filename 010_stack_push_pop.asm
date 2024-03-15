;demo for stack - push/pop
;The storing of a CPU register in the stack is called a PUSH.
;The loading of the contents of the stack back into a CPU register is called a POP.

	org	00h

Main:

;set SP at the default location  - 07h - 0000 0111B
Default:
	mov	R2, #0AAh
	mov	R3, #0BBh
	mov	R4, #0CCh
	mov	R5, #0DDh
	mov	R6, #0EEh
	mov	R7, #0FFh
;demo - Bank0
;demo - 2-7 for R2-R7
	push	2	;the same with 02h - push request direct address
	push	3
	push	4
	push	5
	push	6
	push	7
;now, SP=0Dh


;demo - altered SP - 0x20
Second:
	mov	SP, #20h	;set RAM location 28h as the first stack location

	push	2
	push	3
	push	4
	push	5
	push	6
	push	7
;now, SP=26h


;demo - Bank3
;demo - oprand for mov - Rn
Third:
	setb	PSW.3
	setb	PSW.4

	mov	R2, #22h
	mov	R3, #33h
	mov	R4, #44h
	mov	R5, #55h
	mov	R6, #66h
	mov	R7, #77h


;demo - oprand for PUSH - direct
;demo - alter bank doesn't mean altering SP
Fourth:
	push	1Ah	;R2 In Bank3
	push	1Bh
	push	1Ch
	push	1Dh
	push	1Eh
	push	1Fh
;now, SP=2Ch


;demo - demo - oprand for POP - direct
Fifth:	pop	31h
	pop	32h
	pop	33h
	pop	34h
	pop	35h
	pop	36h 
;now, SP=26h


;demo - stack downflow
;demo - pop invert push
Sixth:
	pop	39h
	pop	3Ah
	pop	3Bh
	pop	3Ch
	pop	3Dh
	pop	3Eh

	pop	3Fh
	pop	40h
	pop	41h
	pop	42h
	pop	43h
	pop	44h

	pop	45h
	pop	46h
	pop	47h
	pop	48h
	pop	49h
	pop	4Ah
;now, SP=14h


;demo - stack overflow
Seventh:
	clr	PSW.3
	clr	PSW.4

	push	2
	push	3
	push	4
	push	5
	push	6
	push	7

	push	2
	push	3
	push	4
	push	5
	push	6
	push	7

	push	2
	push	3
	push	4
	push	5
	push	6
	push	7

	push	2
	push	3
	push	4
	push	5
	push	6
	push	7

	push	2
	push	3
	push	4
	push	5
	push	6
	push	7

	push	2
	push	3
	push	4
	push	5
	push	6
	push	7

	push	2
	push	3
	push	4
	push	5
	push	6
	push	7
;now, SP=4Dh

	end

	


	