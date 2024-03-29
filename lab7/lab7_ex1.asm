;=================================================
; Name: Ana Cardenas Beltran
; Email: acard079@ucr.edu
; 
; Lab: lab 6, ex 1
; Lab section: 21
; TA: David Feng
; 
;=================================================
;MAIN
;=================================================
.ORIG x3000

LD R6, SUB_1_3200
JSRR R6

	ADD R2, R1, #1
LD R6, SUB_PRINT_DEC
JSRR R6

HALT
;DATA
SUB_1_3200	.FILL x3200
SUB_PRINT_DEC	.FILL x3400

;=================================================
;SUBROUTINE: SUB_1_3200
;-TAKES IN A HARD-CODED .FILL VALUE AND LOADS IT TO REGISTER 1
;=================================================
.ORIG x3200

ST R7, BACKUP_R7_3200

	LD R1, VALUE	

LD R7, BACKUP_R7_3200
	
	RET
;DATA
BACKUP_R1_3200	.BLKW #1
BACKUP_R7_3200	.BLKW #1
VALUE			.FILL #-27671
;======================================================
;SUBROUTINE: SUB_PRINT_DEC_3400
;PRINT VALUE+1 TO CONSOLE AS A DEC NUMBER
;======================================================
.ORIG x3400

ST R2, BACKUP_R2_3400
ST R3, BACKUP_R3_3400
ST R7, BACKUP_R7_3400
	
	LD R0, NEWLINE
	OUT
	
	ADD R3, R2, #0
	BRn NEG
	BRzp CHECK_10000
NEG
	LD R0, ASCII_NEG
	OUT
	NOT R2, R2
	ADD R2, R2, #1		;OUTPUT NEGATIVE THEN TAKE 2'S COMPLEMENT
	BRnzp CHECK_10000
CHECK_10000
	AND R0, R0 ,x0
	LD R4, ASCII_10000
	ADD R4, R4, R2			;TEST TO SEE IF FIRST DIGIT IS IN THE 10000'S PLACE
	BRzp IS_10000			;IF POSITIVE OR ZERO, THERE WAS A 10000TH DIGIT
	BRn CHECK_1000			;IF NEG, CHECK TO SEE IF THERE IS A 1000TH DIGIT
CHECK_1000
	LD R4, ASCII_1000
	ADD R3, R4, R2
	BRzp IS_1000
	BRn	CHECK_100
CHECK_100
	LD R4, ASCII_100
	ADD R3, R4, R2
	BRzp IS_100
	BRn CHECK_10
CHECK_10
	LD R4, ASCII_10
	ADD R3, R4, R2
	BRzp IS_10
	BRn IS_1

IS_10000							;WILL OUTPUT DIGIT IN THE 10000S PLACE
		LD R4, ASCII_10000
		ADD R2, R4, R2				;R2-10000 IN R2
		BRn NO_MORE_10000
		BRzp CONTINUE_10000
	CONTINUE_10000
		ADD R0, R0, #1
		BRzp CHECK_NEXT_10000
	CHECK_NEXT_10000
		ADD R2, R4, R2				;SUBTRACT 10000 FROM CURR VALUE OF R5
		BRn NO_MORE_10000
		BRzp CONTINUE_10000
	NO_MORE_10000
		NOT R4, R4
		ADD R4, R4, #1
		ADD R2, R4, R2				;RESTORE VALUE OF R5
		LD R4, ASCII_ZERO
		ADD R0, R0, R4
		OUT
		BRnzp PRE_IS_1000
	PRE_IS_1000					;R5 HAS THE VALUE I WILL USE TO OUTPUT DIGIT IN 1000S PLACE
		AND R0, R0, x0
		BRz IS_1000
IS_1000
		LD R4, ASCII_1000
		ADD R2, R2, R4		;SUBTRACT 1000 AND PLACE IN R2
		BRn NO_MORE_1000
		BRzp CONTINUE_1000
	CONTINUE_1000
		ADD R0, R0, #1
		BRzp CHECK_NEXT_1000
	CHECK_NEXT_1000
		ADD R2, R2, R4		;SUBTRACT 1000 FROM CURR VALUE OF R2
		BRn NO_MORE_1000
		BRzp CONTINUE_1000	;IF NUM ISN'T NEGATIVE, KEEP INCREASING R0
	NO_MORE_1000
		NOT R4, R4
		ADD R4, R4, #1		;GET 1000
		ADD R2, R4, R2		;RESTORE R2
		LD R4, ASCII_ZERO
		ADD R0, R0, R4		;ADD 48 TO R0 TO OUTPUT TO CONSOLE
		OUT
		BRnzp PRE_IS_100
	PRE_IS_100
		AND R0, R0, x0
		BRz IS_100
IS_100						;R2 CONTAINS THE VALUE I WANT TO USE TO OUTPUT THE 100S PLACE
		LD R4, ASCII_100
		ADD R2, R2, R4
		BRn NO_MORE_100
		BRzp CONTINUE_100
	CONTINUE_100
		ADD R0, R0, #1
		BRzp CHECK_NEXT_100
	CHECK_NEXT_100
		ADD R2, R2, R4		;R5-100
		BRn NO_MORE_100
		BRzp CONTINUE_100
	NO_MORE_100
		NOT R4, R4
		ADD R4, R4, #1
		ADD R2, R2, R4			;RESTORE VALUE OF R5
		LD R4, ASCII_ZERO
		ADD R0, R0, R4			;ADD 48 TO OUTPUT TO CONSOLE
		OUT
		BRnzp PRE_IS_10
	PRE_IS_10
		AND R0, R0, x0
		BRz IS_10
IS_10
		LD R4, ASCII_10
		ADD R2, R2, R4		;SUBTRACT 1000 AND PLACE IN R2
		BRn NO_MORE_10
		BRzp CONTINUE_10
	CONTINUE_10
		ADD R0, R0, #1
		BRzp CHECK_NEXT_10
	CHECK_NEXT_10
		ADD R2, R2, R4		;SUBTRACT 1000 FROM CURR VALUE OF R2
		BRn NO_MORE_10
		BRzp CONTINUE_10	;IF NUM ISN'T NEGATIVE, KEEP INCREASING R0
	NO_MORE_10
		NOT R4, R4
		ADD R4, R4, #1		;GET 1000
		ADD R2, R4, R2		;RESTORE R2
		LD R4, ASCII_ZERO
		ADD R0, R0, R4		;ADD 48 TO R0 TO OUTPUT TO CONSOLE
		OUT
		BRnzp PRE_IS_1
	PRE_IS_1
		AND R0, R0, x0
		BRz IS_1

IS_1						;R2 CONTAINS THE VALUE I WANT TO USE TO OUTPUT THE 100S PLACE
		LD R4, ASCII_1
		ADD R2, R2, R4
		BRn NO_MORE_1
		BRzp CONTINUE_1
	CONTINUE_1
		ADD R0, R0, #1
		BRzp CHECK_NEXT_1
	CHECK_NEXT_1
		ADD R2, R2, R4		;R5-100
		BRn NO_MORE_1
		BRzp CONTINUE_1
	NO_MORE_1
		NOT R4, R4
		ADD R4, R4, #1
		ADD R2, R2, R4			;RESTORE VALUE OF R5
		LD R4, ASCII_ZERO
		ADD R0, R0, R4			;ADD 48 TO OUTPUT TO CONSOLE
		OUT
		BRnzp THE_END_3400

THE_END_3400
		
LD R2, BACKUP_R2_3400
LD R3, BACKUP_R3_3400
LD R7, BACKUP_R7_3400

	RET

;DATA
BACKUP_R7_3400	.FILL #1
BACKUP_R2_3400	.FILL #1
BACKUP_R3_3400	.FILL #1
ASCII_ZERO		.FILL #48
NEWLINE			.FILL '\n'
ASCII_NEG		.FILL #45
ASCII_10000		.FILL #-10000
ASCII_1000		.FILL #-1000
ASCII_100		.FILL #-100
ASCII_10		.FILL #-10
ASCII_1			.FILL #-1

.END	
