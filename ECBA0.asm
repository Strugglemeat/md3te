;this is for player 2 - originally from 44464
;this is code for AFTER p2 has selected

OriginalCode:
	btst.b #1,$8(A5)
	bne.b Go44488
	jmp LeaveWithoutDoingAnything

Go44488:
	cmpi.b #01,$10FFFD ;is loser byte set to 1? (player 1 lost and P2 is in control)
	beq LeaveWithoutDoingAnything

	;the below is after P2 has selected
	move.b $1000FB,$1000FA ;copy p2 to p1
	move.b $7(A5),$6(A5) ;copy p2 to p1 (cursor)

	move.b #00,$10FFFD ;reset loser byte
	move.b #$7B,$8(A5) ;set status to both have selected
	move.b #00,$10FFFB ;reset random byte
	jmp $44488 original after chr selected pick

LeaveWithoutDoingAnything:
	jmp $4446C