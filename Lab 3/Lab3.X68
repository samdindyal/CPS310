*-----------------------------------------------------------
* Program    :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
	ORG	$1000
START:				; first instruction of program
	
	MOVE.W		#9,d0
	MOVE.W		a,-(sp)
	MOVE.W		b,-(sp)
	MOVE.L		#x,-(sp)
	JSR		QUAD
	ADD.W		#8,sp	

	TRAP		#15	
	

* Variables and Strings
QUAD
	
	
	CLR.W	d2
	CLR.W	d3
	
	ADD.W	a,d2
	ADD.W	a,d2
	ADD.W	a,d2	;d2 = 3a
	
	
	ADD.W	b,d3
	ADD.W	b,d3	;d3 = 2b
	
	
	JSR	SQRT
	
	ADD.W	d2,d5	
	
	CLR.W	d1
	CLR.W	d0
	MOVE.W	#3,d0
	MOVE.W	d5,d1
	
	TRAP	#15
	MOVE.W	#9,d0
	TRAP	#15

	RTS


SQRT
	CLR.W	d4
	CLR.W	d5
	MOVE.W	#1,d4
LOOP
	SUB.W	d4,d3
	ADD.W	#2,d4
	ADD.W	#1,d5	;Square root ends up in d5
	CMP.W	#0,d3
	BGE	LOOP
	SUB.W	#1,d5
	RTS

BACKUPSTACK
		MOVE.L	a0,-(sp)
		MOVE.W	d0,-(sp)
		MOVE.W	d1,-(sp)
		MOVE.W	d2,-(sp)
		MOVE.W	d3,-(sp)
		MOVE.W	d4,-(sp)
		RTS

RESTORE
		MOVE.W	(sp)+,d4
		MOVE.W	(sp)+,d3
		MOVE.W	(sp)+,d2
		MOVE.W	(sp)+,d1
		MOVE.W	(sp)+,d0
		MOVEA.L	(sp)+,a0
		RTS		

	ORG	$2000
	
a	DC.W	1
b	DC.W	36
x	DS.W	1

	END	START		; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~8~
