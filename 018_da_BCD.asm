;BCD Addition
;The 8051 performs addition in pure binary - this may lead to errors when performing BCD addition
;Example
;49 BCD 01001001
;38 BCD 00111000
;87 BCD 10000001 (81BCD)
;The result must be adjusted to yield the correct BCD result

;The DA A instruction is for BCD arithmetic operations. 
;In BCD arithmetic, ADD and ADDC instructions should always be followed by a DA A operation,
;to ensure that the result is also in BCD. Note that DA A will not convert a binary number to BCD. 
;The DA A operation produces a meaningfid result only as the second step in the addition of two BCD bytes.

	org	00h


	mov	A, #9	;0000 1001BCD - 0000 1001B
	da	A	;THIS IS MEANINGLESS, SINCE DA WOULD NOT CONVERT DEC TO BCD
	add	A, #11	;0001 0001BCD - 0000 1011B - THIS IS MEANINGLESS, SINCE THERE IS NO "1011" IN BCD.
			;A expecting 20d=0010 0000BCD if these are BCD numbers
			;Ahead of "da A", 0000 1001B + 0000 1011B = 0001 0100B = 18BCD
			;0000 1001BCD + 0001 0001BCD = 0001 1010 = 1Ah

	da	A	;A = 1Ah = 26
			;da - decimal adjust instruction
			;The carry flag is set if the adjusted number exceeds 99 BCD
	da	A
	da	A
	da	A

	clr	A
	mov	A, #13	;0001 0011BCD - 0000 1101B - 0001 0011BCD - 19Dec
	add	A, #27	;0010 0111BCD - 0001 1011B - 0010 0111BCD - 39Dec
	;THE TWO OPRANDS ARE ALL MEANINGLESS, SINCE THERE IS NO "1101" AND "1011" IN BCD.
			;A expecting 40BCD=0100 0000B if these are BCD numbers
			;0001 0011BCD + 0010 0111BCD = 0011 1010B = 3Ah
			;0000 1101B + 0001 1011B = 0010 1000B = 40Dec

	clr	A	;Below demo add 19DEC and 39DEC equals add 13BCD and 27BCD
	mov	A, #19	;0001 0011BCD - 0000 1101B - 0001 0011BCD - 19Dec
	add	A, #39	;0010 0111BCD - 0001 1011B - 0010 0111BCD - 39Dec
			;A expecting 40BCD=0100 0000B if these are BCD numbers
			;0001 0011BCD + 0010 0111BCD = 0011 1010B = 3Ah = 58Dec
			;0000 1101B + 0001 1011B = 0010 1000B = 40D
			;58Dec = 0011 1010B = 0101 1000BCD

	da	A	;A = 40h = 0100 0000BCD, this is what expected for 13BCD+27BCD=40BCD

	da	A	;THE LATTER 3 DA DEMO DA NEED ONLY RUN ONCE ONE TIME
	da	A
	da	A


	end
