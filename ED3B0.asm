;coming from 276DA

CheckLoserByte:
	cmpi.b #00,$10FFFD ;has no one lost yet? then leave
	bne WhichPlayerAreWe
	cmpi.b #$80,$4(A5) ;is P1 pressing D? $100044
	beq TurnOnRandom
	cmpi.b #$80,$8(A5) ;is P2 pressing D? $100048
	beq TurnOnRandom
	jmp NormalExit

WhichPlayerAreWe:
	tst.w D1 ;0=P1 1=P2
	bne CheckLoserByteP2

;the below code ONLY prevents a player from selecting if they aren't allowed

CheckLoserByteP1:
	cmpi.b #01,$10FFFD ;did player 1 lose last time?
	bne NobodyPicked ;if player 1 did NOT lose, they can't pick
	jmp CheckIfEitherPressedButtonD ;player 1 did lose, now they can pick like normal

CheckLoserByteP2:
	cmpi.b #02,$10FFFD
	bne NobodyPicked ;if P2 did NOT lose, they can't pick
	jmp CheckIfEitherPressedButtonD

NobodyPicked:
	jmp $277be

CheckIfEitherPressedButtonD:
	tst.w D1 ;0=P1 1=P2
	bne CheckRandomPressP2
	cmpi.b #$80,$4(A5) ;is P1 pressing D? $100044
	bne NormalExit
	bra TurnOnRandom

CheckRandomPressP2:
	cmpi.b #$80,$8(A5) ;is P2 pressing D? $100048
	bne NormalExit

TurnOnRandom:
	cmpi.b #01,$10FFFC ;is random already on?
	beq NormalExit

	move.b D1,$10FFFB ;store this from D1 so we can use D1 register
	move.b $1014Ec,D1 ;subseconds
	ASR #4,D1 ;divide it by 4
	add.b D1,$10FFFE ;seed random with 0 thru 4 (at least it's not just always 0x00)
	move.b $10FFFB,D1 ;restore D1
	move.b #01,$10FFFC ;random flag is on

NormalExit:
	jmp $276E0