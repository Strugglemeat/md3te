;this is for player 1 - coming from 4445A
;this is code for AFTER p1 has selected

OriginalCode:
	btst.b #0,$8(A5)
	bne.b Go444A0
	jmp LeaveWithoutDoingAnything

Go444A0:
	cmpi.b #02,$10FFFD ;is loser byte set to 2? (player 2 lost and P1 is in control)
	beq LeaveWithoutDoingAnything

	;the below is after P1 has selected
	move.b $1000FA,$1000FB ;copy p2 to p1
	move.b $6(A5),$7(A5) ;copy p1 to p2 (cursor)

	move.b #00,$10FFFD ;reset loser byte
	move.b #$7B,$8(A5) ;set status to both have selected
	move.b #00,$10FFFB ;reset random byte
	jmp $44488 original after chr selected pick

LeaveWithoutDoingAnything:
	jmp $44462