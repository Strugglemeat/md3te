;coming from 276DA

CheckLoserByte:
	cmpi.b #00,$10FFFD ;has no one lost yet? then leave
	bne WhichPlayerAreWe
	cmpi.b #$80,$100044 ;is P1 pressing D?
	beq TurnOnRandom
	cmpi.b #$80,$100048 ;is P2 pressing D?
	beq TurnOnRandom
	jmp NormalExit

WhichPlayerAreWe:
	tst.w D1 ;0=P1 1=P2
	bne CheckLoserByteP2

;the below code ONLY prevents a player from selecting if they aren't allowed

CheckLoserByteP1:
	cmpi.b #01,$10FFFD ;did player 1 lose last time?
	bne NobodyPicked ;if player 1 did NOT lose, they can't pick
	jmp DidTheyPressRandom ;jmp NormalExit ;player 1 did lose, now they can pick like normal

CheckLoserByteP2:
	cmpi.b #02,$10FFFD
	bne NobodyPicked ;if P2 did NOT lose, they can't pick
	jmp DidTheyPressRandom ;jmp NormalExit

NobodyPicked:
	jmp $277be

DidTheyPressRandom:
	tst.w D1 ;0=P1 1=P2
	bne CheckRandomPressP2
	cmpi.b #$80,$100044 ;is P1 pressing D?
	bne NormalExit
	bra TurnOnRandom

CheckRandomPressP2:
	cmpi.b #$80,$100048 ;is P2 pressing D?
	bne NormalExit

TurnOnRandom:
	move.b #01,$10FFFC ;random is on

NormalExit:
	jmp $276E0