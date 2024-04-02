;demo for subb
;SUBB (subtract with borrow) when CY=0
;reference - https://what-when-how.com/8051-microcontroller/arithmetic-instructions/

;In many microprocessors there are two different instructions for subtraction: SUB and SUBB (subtract with borrow). 
;In the 8051 we have only SUBB. To make SUB out of SUBB, we have to make CY = 0 prior to the execution of the instruction. 
;Therefore, there are two cases for the SUBB instruction: (1) with CY = 0, and (2) with CY = 1. 
;First we examine the case where CY = 0 prior to the execution of SUBB. 
;Notice that we use the CY flag for the borrow.

;In subtraction, the 8051 microprocessors (indeed, all modern CPUs) use the 2\u2032s complement method. 
;Although every CPU contains adder circuitry, it would be too cumbersome (and take too many transistors) to design separate subtracter circuitry. 
;For this reason, the 8051 uses adder circuitry to perform the subtraction command. 
;Assuming that the 8051 is executing a simple subtract instruction and that CY = 0 prior to the execution of the instruction, 
;one can summarize the steps of the hardware of the CPU in executing the SUBB instruction for unsigned numbers, as follows.

;1.Take the 2's complement of the subtrahend (source operand).
;2.Add it to the minuend (A).
;3.Invert the carry.

;These three steps are performed for every SUBB instruction by the internal hardware of the 8051 CPU, 
;regardless of the source of the operands, provided that the addressing mode is supported. 
;After these three steps the result is obtained and the flags are set. 
;The code below illustrates the three steps.

;signed number = negtive signed number
;0 - 0000 0000B
;1-127 - 0000 0001B - 0111 1111B
;-1 - -128 - 1111 1111B - 1000 0000B


	org	00h
	sjmp	Setup	;2 bytes instruction

Setup:
	clr	cy
	
Substract:
	clr	cy
	clr	A
	mov	B, A
	mov	A, #4Eh		;lack of # would be address
	mov	B, #7Fh		;lack of # would be address
	subb	A, B	;-31h
	jnc	Out
	dec	A	;dec A + cpl A = cpl A + inc A
	cpl	A	;A - 2'complement of result is only for negtive number

	clr	cy
	clr	A
	mov	B, A
	mov	A, #4Eh
	mov	B, #7Fh
	subb	A, B
	jnc	Out
	cpl	A
	inc	A

	clr	cy
	clr	A
	mov	B, A
	mov	A, #7Fh	;subtrahend (source operand)
	mov	B, #4Eh	;
	subb	A, B	;result is positive
	jnc	Out

Out:
	end

	