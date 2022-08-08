AllowRandomIncrementing:
	cmpi.b #01,$10FFFC ;is random on?
	bne TimerReset
	cmpi.b #$78,$8(A6) ;have we selected?
	bne TimerReset

RandomIncrementer:
	addi.b #01,$10FFFE ;add 1 to "random" chr sel
	cmpi.b #$17,$10FFFE ;is it 17?
	ble TimerReset ;if it's less than or equal to 17, skip past the reset
	move.b #00,$10FFFE ;reset it to 00 if it's beyond x17

TimerReset:
	cmpi.b #00,$1014ED ;timer
	bgt RandomCheck
	cmpi.b #00,$10FFFD ;is loser byte set?
	bne RandomCheck ;bne WhichPlayerCheck ;if we don't have loser byte set, we can allow timer to select
	move.b #$58,$1014ED ;reset the timer if it's the first round (don't allow timer select)

RandomCheck:
	cmpi.b #01,$10FFFC ;is random on?
	bne ProceedCheck
	move.b $10FFFE,$6(A6)
	move.b $6(A6),$7(A6) 

ProceedCheck:
	cmpi.b #00,$10FFFD
	beq OriginalCode

;this code just locks the cursors together

WhichPlayerCheck:
	cmpi.b #01,D1 ;which player are we? 00=P1, 01=P2
	beq WeArePlayer2

WeArePlayer1:
	cmpi.b #01,$10FFFD ;player 1 - did they lose last time?
	beq OriginalCode ;we are player 1 and player 1 lost last time - proceed as usual
	move.b $7(A6),$6(A6) ;we are player 1 and player 1 WON last time - set them to P2's
	jmp LeaveToChangeCursor

WeArePlayer2:
	cmpi.b #02,$10FFFD ;player 2 - did they lose last time?
	beq OriginalCode ;we are player 2 and player 2 lost last time - proceed as usual
	move.b $6(A6),$7(A6) 	;move.b $1014e6,$1014e7
	jmp LeaveToChangeCursor

OriginalCode:
	cmp.b (A4,D1),D3 ;is D3 equal to P1=1014e6 P2=1014e7?
	beq Jump2780A ;if they are equal (don't need to switch), leave
	jmp LeaveToChangeCursor

Jump2780A:
	jmp $2780A ;rts, no changing

LeaveToChangeCursor:
	jmp $277FC
