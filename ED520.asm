AllowRandomIncrementing:
	cmpi.b #01,$10FFFC ;is random on?
	bne ProceedCheck
	cmpi.b #$78,$8(A6) ;have we selected?
	bne ProceedCheck

RandomIncrementer:
	add.b D1,$10FFFE
	cmpi.b #$17,$10FFFE ;is it 17?
	ble SetRandom ;if it's less than or equal to 17, skip past the reset
	move.b #00,$10FFFE ;reset it to 00 if it's beyond x17

SetRandom:
	move.b $10FFFE,$6(A6)
	move.b $6(A6),$7(A6)
	;move.b $10FFFE,$1000FA
	;move.b $1000FA,$1000FB

ProceedCheck:
	cmpi.b #00,$10FFFD ;is loser byte off?
	beq TimerCheck

;this code locks the cursors together

WhichPlayerCheck:
	cmpi.b #01,D1 ;which player are we? 00=P1, 01=P2
	beq WeArePlayer2

WeArePlayer1:
	cmpi.b #01,$10FFFD ;player 1 - did they lose last time?
	beq Leave ;we are player 1 and player 1 lost last time - proceed as usual
	move.b $7(A6),$6(A6) ;we are player 1 and player 1 WON last time - set them to P2's
	jmp Leave

WeArePlayer2:
	cmpi.b #02,$10FFFD ;player 2 - did they lose last time?
	beq Leave ;we are player 2 and player 2 lost last time - proceed as usual
	move.b $6(A6),$7(A6) 	;move.b $1014e6,$1014e7
	jmp Leave

TimerCheck: ;note that this check only happens when loser byte is OFF
	cmpi.b #00,$7(A4) ;timer $1014ED
	bgt Leave
	move.b #01,$6(A6) ;magician in P1
	move.b #01,$7(A6) ;magician in P2

Leave:
	jmp $277FC
